module Context = Context

(** Copy CSS files into the target (taking account of themes using [ctx].) *)
val copy_css : Context.t -> unit Yocaml.t

(** Copy Images files into the target (taking account of themes using [ctx].) *)
val copy_images : Context.t -> unit Yocaml.t
