open Yocaml

type t =
  { main_title : string option
  ; main_desc : string option
  ; main_authors : Human.t list
  ; main_tags : string list
  ; repository : Source_hub.t option
  }

let make main_title main_desc main_authors main_tags repository =
  { main_title
  ; main_desc
  ; main_authors
  ; main_tags = Helper.map_tags main_tags
  ; repository
  }
;;

let neutral = make None None [] [] None

let equal a b =
  Option.equal String.equal a.main_title b.main_title
  && Option.equal String.equal a.main_desc b.main_desc
  && List.equal Human.equal a.main_authors b.main_authors
  && List.equal String.equal a.main_tags b.main_tags
  && Option.equal Source_hub.equal a.repository b.repository
;;

let dmp ppf { main_title; main_desc; main_authors; main_tags; repository } =
  let open Helper in
  pp_record
    "Page"
    ppf
    [ pp_field "main_title" main_title $ Preface.Option.pp pp_quoted_string
    ; pp_field "main_desc" main_desc $ Preface.Option.pp pp_quoted_string
    ; pp_field "main_authors" main_authors $ Preface.List.pp Human.dmp
    ; pp_field "main_tags" main_tags $ Preface.List.pp pp_quoted_string
    ; pp_field "repository" repository $ Preface.Option.pp Source_hub.dmp
    ]
;;

let from (type a) (module Validable : Metadata.VALIDABLE with type t = a) =
  Validable.object_and (fun obj ->
      let open Validable in
      let open Validate.Infix in
      make
      <$> optional_assoc string "main_title" obj
      <*> optional_assoc string "main_desc" obj
      <*> optional_assoc_or
            ~default:[]
            (Human.from_list (module Validable))
            "main_authors"
            obj
      <*> (optional_assoc_or ~default:[] (list_of string) "main_tags" obj
          >|= Helper.map_tags)
      <*> optional_assoc (Source_hub.from (module Validable)) "repository" obj)
;;

let inject
    (type a)
    (module D : Key_value.DESCRIBABLE with type t = a)
    { main_title; main_desc; main_authors; main_tags; repository }
  =
  D.(
    object_
      [ "main_title", Option.fold ~none:null ~some:string main_title
      ; "main_desc", Option.fold ~none:null ~some:string main_desc
      ; "main_authors", list $ List.map (Human.inject (module D)) main_authors
      ; "main_tags", list $ List.map string main_tags
      ; ( "repository"
        , Option.fold
            ~none:null
            ~some:(Source_hub.inject (module D))
            repository )
      ])
;;
