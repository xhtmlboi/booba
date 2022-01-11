let call = Sys.argv.(0)
let version = "1.0.0"

type common_option =
  { theme : string option
  ; target : string option
  ; subfolder : string option
  ; config : string option
  }

let make_common_option theme target subfolder config =
  { theme; target; subfolder; config }
;;

let common_option_desc =
  let open Cmdliner in
  let docs = Manpage.s_common_options in
  let theme =
    let doc =
      Format.asprintf
        "Select a theme definied into [themes/], default: [%s]"
        Config.default_theme
    in
    let arg = Arg.info ~doc ~docs [ "theme"; "t"; "T" ] in
    Arg.(value & opt (some string) None & arg)
  in
  let target =
    let doc =
      Format.asprintf
        "Define the output of the generated website, default: [%s]"
        Config.default_target
    in
    let arg =
      Arg.info
        ~doc
        ~docs
        [ "target"; "destination"; "output"; "o"; "d"; "O"; "D" ]
    in
    Arg.(value & opt (some string) None & arg)
  in
  let subfolder =
    let doc =
      Format.asprintf
        "If the website is to be generated in a subfolder of the target \
         (e.g. the target is [_site] but the site is generated in \
         [_site/my_subsite], which can be convenient if the site is not to \
         be generated at the root of the server (e.g. for a project that is \
         deployed on the [gh-pages] branch generating as the address \
         [https://your-nickname.github.io/your-project] you can give the \
         target that you want and the subfolder [your-project]. \n\n\n\
         default: %s"
        (Option.value
           ~default:"at the root of [target]"
           Config.default_subfolder)
    in
    let arg =
      Arg.info
        ~doc
        ~docs
        [ "subfolder"; "folder"; "into"; "S"; "s"; "f"; "F"; "i"; "I" ]
    in
    Arg.(value & opt (some string) None & arg)
  in
  let config =
    let doc =
      Format.asprintf
        "The path of the global configuration file (default: %s)."
        Config.default_config_file
    in
    let arg =
      Arg.info
        ~doc
        ~docs
        [ "config"; "config-file"; "configuration"; "c"; "C" ]
    in
    Arg.(value & opt (some string) None & arg)
  in
  Term.(const make_common_option $ theme $ target $ subfolder $ config)
;;

let man =
  let open Cmdliner in
  [ `S Manpage.s_authors; `P "The <XHTMLBoy/>" ]
;;

let build task =
  let open Cmdliner in
  let doc = "Build the current directory into a static website" in
  let exits = Term.default_exits in
  Term.(
    ( const task $ common_option_desc
    , Term.info "build" ~version ~doc ~exits ~man ))
;;

let watch task =
  let open Cmdliner in
  let doc = "Serve and watch the static website" in
  let exits = Term.default_exits in
  let port_arg =
    let doc = Format.asprintf "The port (default: %d)" Config.default_port in
    let arg = Arg.info ~doc [ "port"; "P"; "p" ] in
    Arg.(value & opt (some int) None & arg)
  in
  Term.(
    ( const task $ common_option_desc $ port_arg
    , Term.info "watch" ~version ~doc ~exits ~man ))
;;

let program =
  let open Cmdliner in
  let doc = "Build a static website" in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  ( Term.(ret (const (`Help (`Pager, None))))
  , Term.info call ~version ~doc ~sdocs ~exits ~man )
;;
