open Yocaml
module Context = Context

let copy_css ctx =
  Context.(process_css ctx $ Build.copy_file ~into:(css_target ctx))
;;

let copy_images ctx =
  Context.(process_images ctx $ Build.copy_file ~into:(images_target ctx))
;;
