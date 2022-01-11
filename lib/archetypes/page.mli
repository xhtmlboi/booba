(** Description of a Page. *)

(** {1 Types} *)

(** The type describing a page. *)
type t = private
  { page_title : string option
  ; page_desc : string option
  ; page_authors : Human.t list
  ; page_tags : string list
  ; config : Config.t
  }

(** {1 Helpers} *)

val make : string option -> string option -> Human.t list -> string list -> t
val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit
val attach_config : t -> Config.t -> t

(** {1 Injection/Projection} *)

val from
  :  (module Yocaml.Metadata.VALIDABLE with type t = 'a)
  -> 'a
  -> t Yocaml.Validate.t

val from_string
  :  (module Yocaml.Metadata.VALIDABLE)
  -> string option
  -> t Yocaml.Validate.t

val inject
  :  (module Yocaml.Key_value.DESCRIBABLE with type t = 'a)
  -> t
  -> (string * 'a) list
