open Yocaml
module E = Engine.Configure (Yocaml_yaml) (Yocaml_jingoo)

let task ctx =
  let* () = E.copy_css ctx in
  let* () = E.copy_images ctx in
  E.build_page ctx
;;

let get_common_values Cli.{ theme; target; subfolder; config } =
  let theme = Option.value ~default:Config.default_theme theme
  and target = Option.value ~default:Config.default_target target
  and subfolder =
    Preface.Option.Alternative.(subfolder <|> Config.default_subfolder)
    |> Option.value ~default:""
  and config = Option.value ~default:Config.default_config_file config in
  theme, target, subfolder, Filepath.(subfolder |> into target), config
;;

let build_action =
  Cli.build (fun opts ->
      let theme, _target, _subfolder, dest, config = get_common_values opts in
      let context = Engine.Context.make ~theme ~target:dest ~config in
      let contextual_task = task context in
      let () = Logs.app (fun pp -> pp "%s" @@ Quotes.pick ()) in
      Yocaml_unix.execute contextual_task)
;;

let watch_action =
  Cli.watch (fun opts potential_port ->
      let theme, target, subfolder, dest, config = get_common_values opts in
      let port = Option.value ~default:Config.default_port potential_port in
      let context = Engine.Context.make ~theme ~target:dest ~config in
      let contextual_task = task context in
      let () = Yocaml_unix.execute contextual_task in
      let server = Yocaml_unix.serve ~filepath:target ~port contextual_task in
      let () = Logs.app (fun pp -> pp "%s" @@ Quotes.pick ()) in
      let () =
        Logs.info (fun pp ->
            pp "Website alive on http://localhost:%d/%s" port subfolder)
      in
      Lwt_main.run server)
;;

let () =
  let () = Logs.set_level ~all:true (Some Logs.Info) in
  let () = Logs.set_reporter (Logs_fmt.reporter ()) in
  let open Cmdliner in
  Term.(exit @@ eval_choice Cli.program [ build_action; watch_action ])
;;
