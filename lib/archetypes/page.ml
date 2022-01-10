open Yocaml

type t =
  { page_title : string option
  ; page_desc : string option
  ; page_authors : Human.t list
  ; page_tags : string list
  }

let make page_title page_desc page_authors page_tags =
  { page_title
  ; page_desc
  ; page_authors
  ; page_tags = Helper.map_tags page_tags
  }
;;

let equal a b =
  Option.equal String.equal a.page_title b.page_title
  && Option.equal String.equal a.page_desc b.page_desc
  && List.equal Human.equal a.page_authors b.page_authors
  && List.equal String.equal a.page_tags b.page_tags
;;

let dmp ppf { page_title; page_desc; page_authors; page_tags } =
  let open Helper in
  pp_record
    "Page"
    ppf
    [ pp_field "page_title" page_title $ Preface.Option.pp pp_quoted_string
    ; pp_field "page_desc" page_desc $ Preface.Option.pp pp_quoted_string
    ; pp_field "page_authors" page_authors $ Preface.List.pp Human.dmp
    ; pp_field "page_tags" page_tags $ Preface.List.pp pp_quoted_string
    ]
;;

let from (type a) (module Validable : Metadata.VALIDABLE with type t = a) =
  Validable.object_and (fun obj ->
      let open Validable in
      let open Validate.Infix in
      make
      <$> optional_assoc string "page_title" obj
      <*> optional_assoc string "page_desc" obj
      <*> optional_assoc_or
            ~default:[]
            (Human.from_list (module Validable))
            "page_authors"
            obj
      <*> (optional_assoc_or ~default:[] (list_of string) "page_tags" obj
          >|= Helper.map_tags))
;;

let inject
    (type a)
    (module D : Key_value.DESCRIBABLE with type t = a)
    { page_title; page_desc; page_authors; page_tags }
  =
  D.(
    object_
      [ "page_title", Option.fold ~none:null ~some:string page_title
      ; "page_desc", Option.fold ~none:null ~some:string page_desc
      ; "page_authors", list $ List.map (Human.inject (module D)) page_authors
      ; "page_tags", list $ List.map string page_tags
      ])
;;
