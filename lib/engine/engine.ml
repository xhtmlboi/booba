open Yocaml
module Context = Context

let binary_update = Build.watch Sys.argv.(0)

let failure () =
  Build.make Deps.empty (function
      | Preface.Validation.Valid x -> Effect.return x
      | Preface.Validation.Invalid x -> Effect.throw (Error.List x))
;;

module Configure (V : Metadata.VALIDABLE) (R : Yocaml.Metadata.RENDERABLE) =
struct
  let copy_css ctx =
    Context.(process_css ctx $ Build.copy_file ~into:(css_target ctx))
  ;;

  let copy_images ctx =
    Context.(process_images ctx $ Build.copy_file ~into:(images_target ctx))
  ;;

  let read_metadata file =
    let open Build in
    read_file file >>^ V.from_string >>> failure ()
  ;;

  let read_configuration file =
    let open Build in
    read_metadata file >>^ Archetypes.Config.from (module V) >>> failure ()
  ;;

  let build_page ctx =
    let global_layout = Context.template ctx "layout.tpl.html" in
    Context.process_pages ctx (fun ~base_file ~page_link:_ ~page_target ->
        let open Build in
        create_file
          page_target
          (binary_update
          >>> read_configuration (Context.get_config ctx)
          >>^ (fun x -> x, ())
          >>> snd
                (read_file_with_metadata
                   (module V)
                   (module Archetypes.Page)
                   base_file)
          >>^ (fun (config, (page, content)) ->
                Archetypes.Page.attach_config page config, content)
          >>> Yocaml_markdown.content_to_html ()
          >>> apply_as_template
                (module Archetypes.Page)
                (module R)
                global_layout
          >>^ Stdlib.snd))
  ;;
end
