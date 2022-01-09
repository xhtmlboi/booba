open Yocaml

type firstname = string
type lastname = string

type t =
  { nickname : string
  ; name : (lastname * firstname) option
  ; mail : string option
  ; bio : string option
  ; links : Link.t list
  }

let make nickname name mail bio links = { nickname; name; mail; bio; links }

let equal a b =
  String.equal a.nickname b.nickname
  && Option.equal (Preface.Pair.equal String.equal String.equal) a.name b.name
  && Option.equal String.equal a.mail b.mail
  && Option.equal String.equal a.bio b.bio
  && List.equal Link.equal a.links b.links
;;

let dmp ppf { nickname; name; mail; bio; links } =
  let open Helper in
  pp_record
    "Human"
    ppf
    [ pp_field "nickname" nickname pp_quoted_string
    ; pp_field "name" name
      $ Preface.Option.pp (Preface.Pair.pp pp_quoted_string pp_quoted_string)
    ; pp_field "mail" mail $ Preface.Option.pp pp_quoted_string
    ; pp_field "bio" bio $ Preface.Option.pp pp_quoted_string
    ; pp_field "links" links $ Preface.List.pp Link.dmp
    ]
;;

let name_from (type a) (module Validable : Metadata.VALIDABLE with type t = a)
  =
  Validable.object_and (fun obj ->
      let open Validable in
      let open Validate.Infix in
      (fun x y -> x, y)
      <$> required_assoc string "lastname" obj
      <*> required_assoc string "firstname" obj)
;;

let links_from
    (type a)
    (module Validable : Metadata.VALIDABLE with type t = a)
  =
  Validable.list_of $ Link.from (module Validable)
;;

let from (type a) (module Validable : Metadata.VALIDABLE with type t = a) =
  Validable.object_and (fun obj ->
      let open Validable in
      let open Validate.Infix in
      make
      <$> required_assoc string "nickname" obj
      <*> optional_assoc (name_from (module Validable)) "name" obj
      <*> optional_assoc string "mail" obj
      <*> optional_assoc string "bio" obj
      <*> optional_assoc_or
            ~default:[]
            (links_from (module Validable))
            "links"
            obj)
;;

let inject
    (type a)
    (module D : Key_value.DESCRIBABLE with type t = a)
    { nickname; name; mail; bio; links }
  =
  D.(
    object_
      [ "nickname", string nickname
      ; ( "name"
        , Option.fold
            ~none:null
            ~some:(fun (x, y) ->
              object_ [ "lastname", string x; "firstname", string y ])
            name )
      ; "mail", Option.fold ~none:null ~some:string mail
      ; "bio", Option.fold ~none:null ~some:string bio
      ; "links", list $ List.map (Link.inject (module D)) links
      ])
;;
