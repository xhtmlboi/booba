open Yocaml

(* I use inline records for extension purpose *)
type t =
  | Gitlab of
      { base_url : string
      ; branch : string
      }
  | Github of
      { base_url : string
      ; branch : string
      }

let make kind base_url branch =
  match String.trim $ String.lowercase_ascii kind with
  | "github" -> Validate.valid $ Github { base_url; branch }
  | "gitlab" -> Validate.valid $ Gitlab { base_url; branch }
  | k -> Error.(to_validate $ Unknown k)
;;

let dmp ppf = function
  | Gitlab { base_url; branch } ->
    let open Helper in
    pp_record
      "Gitlab"
      ppf
      [ pp_field "base_url" base_url pp_quoted_string
      ; pp_field "branch" branch pp_quoted_string
      ]
  | Github { base_url; branch } ->
    let open Helper in
    pp_record
      "Github"
      ppf
      [ pp_field "base_url" base_url pp_quoted_string
      ; pp_field "branch" branch pp_quoted_string
      ]
;;

let equal a b =
  match a, b with
  | Gitlab a, Gitlab b ->
    String.equal a.base_url b.base_url && String.equal a.branch b.branch
  | Github a, Github b ->
    String.equal a.base_url b.base_url && String.equal a.branch b.branch
  | _ -> false
;;

let from (type a) (module Validable : Metadata.VALIDABLE with type t = a) =
  Validable.object_and (fun obj ->
      let open Validable in
      let open Validate.Infix in
      make
      <$> required_assoc string "hub" obj
      <*> required_assoc string "base_url" obj
      <*> required_assoc string "branch" obj
      |> Validate.Monad.join)
;;

let inject (type a) (module D : Key_value.DESCRIBABLE with type t = a)
  = function
  | Gitlab { base_url; branch } ->
    D.(
      object_
        [ "hub", string "gitlab"
        ; "base_url", string base_url
        ; "branch", string branch
        ])
  | Github { base_url; branch } ->
    D.(
      object_
        [ "hub", string "gitlab"
        ; "base_url", string base_url
        ; "branch", string branch
        ])
;;

let ( // ) = Filename.concat

let prefix uri =
  if String.starts_with ~prefix:"https://" uri
     || String.starts_with ~prefix:"http://" uri
  then uri
  else "https://" ^ uri
;;

let link k t path =
  match t with
  | Gitlab { base_url; branch } ->
    prefix base_url // "-" // k // branch // path
  | Github { base_url; branch } -> prefix base_url // k // branch // path
;;

let blob = link "blob"
let tree = link "tree"
let edit = link "edit"
