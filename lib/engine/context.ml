open Yocaml

type t =
  { target : string
  ; theme : string
  ; config : string
  }

let ( // ) = Filename.concat
let make ~theme ~target ~config = { theme; target; config }

let equal a b =
  String.equal a.theme b.theme
  && String.equal a.target b.target
  && String.equal a.config b.config
;;

let dmp ppf { theme; target; config } =
  let open Archetypes.Helper in
  pp_record
    "Context"
    ppf
    [ pp_field "theme" theme pp_quoted_string
    ; pp_field "target" target pp_quoted_string
    ; pp_field "config" config pp_quoted_string
    ]
;;

let get_config { config; _ } = config
let theme_path { theme; _ } = "themes" // theme
let target_path { target; _ } = target
let css_target ctx = target_path ctx // "css"
let images_target ctx = target_path ctx // "images"
let template ctx path = theme_path ctx // "templates" // path

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

let normalize_name file = basename $ replace_extension file "html"

let process_pages ctx callback =
  Yocaml.process_files
    [ "pages" ]
    Filepath.(with_extension "md")
    (fun file ->
      let base_file = file in
      let page_link = normalize_name file in
      let page_target = target_path ctx // page_link in
      callback ~base_file ~page_link ~page_target)
;;
