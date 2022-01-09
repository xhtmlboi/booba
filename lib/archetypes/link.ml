open Yocaml

type name = string
type url = string

type t =
  { name : name
  ; url : url
  }

let make name url = { name; url }
let equal a b = String.equal a.name b.name && String.equal a.url b.url

let dmp ppf { name; url } =
  let open Helper in
  pp_record
    "Link"
    ppf
    [ pp_field "name" name pp_quoted_string
    ; pp_field "url" url pp_quoted_string
    ]
;;

let from (type a) (module Validable : Metadata.VALIDABLE with type t = a) =
  Validable.object_and (fun obj ->
      let open Validable in
      let open Validate.Infix in
      make
      <$> required_assoc string "name" obj
      <*> required_assoc string "url" obj)
;;

let inject
    (type a)
    (module D : Key_value.DESCRIBABLE with type t = a)
    { name; url }
  =
  D.(object_ [ "name", string name; "url", string url ])
;;
