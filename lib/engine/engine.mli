module Context = Context

module Configure
    (V : Yocaml.Metadata.VALIDABLE)
    (R : Yocaml.Metadata.RENDERABLE) : sig
  val copy_css : Context.t -> unit Yocaml.t
  val copy_images : Context.t -> unit Yocaml.t
  val build_page : Context.t -> unit Yocaml.t
end
