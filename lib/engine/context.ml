open Yocaml

type t =
  { target : string
  ; theme : string
  }

let ( // ) = Filename.concat
let make ~theme ~target = { theme; target }
let equal a b = String.equal a.theme b.theme && String.equal a.target b.target

let dmp ppf { theme; target } =
  let open Archetypes.Helper in
  pp_record
    "Context"
    ppf
    [ pp_field "theme" theme pp_quoted_string
    ; pp_field "target" target pp_quoted_string
    ]
;;

let theme_path { theme; _ } = "themes" // theme
let target_path { target; _ } = target
let css_target ctx = target_path ctx // "css"
let images_target ctx = target_path ctx // "images"

let process_css ctx =
  Yocaml.process_files [ "css"; theme_path ctx // "css" ]
  $ Filepath.with_extension "css"
;;

let process_images ctx =
  Yocaml.process_files
    [ "images"; theme_path ctx // "images" ]
    Preface.Predicate.(
      Filepath.(
        with_extension "png"
        || with_extension "gif"
        || with_extension "jpg"
        || with_extension "jpeg"
        || with_extension "svg"))
;;
