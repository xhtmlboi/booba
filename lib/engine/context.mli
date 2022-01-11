(** Define a context for a YOCaml build process. *)

(** {1 Types} *)

(** The context. *)
type t

(** {1 Helper} *)

val make : theme:string -> target:string -> config:string -> t
val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit

(** {1 resolve path} *)

val get_config : t -> Yocaml.Filepath.t
val theme_path : t -> Yocaml.Filepath.t
val target_path : t -> Yocaml.Filepath.t
val css_target : t -> Yocaml.Filepath.t
val images_target : t -> Yocaml.Filepath.t
val template : t -> Yocaml.Filepath.t -> Yocaml.Filepath.t
val process_css : t -> (Yocaml.Filepath.t -> unit Yocaml.t) -> unit Yocaml.t

val process_images
  :  t
  -> (Yocaml.Filepath.t -> unit Yocaml.t)
  -> unit Yocaml.t

val process_pages
  :  t
  -> (base_file:Yocaml.Filepath.t
      -> page_link:string
      -> page_target:Yocaml.Filepath.t
      -> unit Yocaml.t)
  -> unit Yocaml.t
