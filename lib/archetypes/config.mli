(** Describes the configuration of the website. *)

type t = private
  { main_title : string option
  ; main_desc : string option
  ; main_authors : Human.t list
  ; main_tags : string list
  ; repository : Source_hub.t option
  }

(** {1 Helpers} *)

val make
  :  string option
  -> string option
  -> Human.t list
  -> string list
  -> Source_hub.t option
  -> t

val neutral : t
val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit

(** {1 Injection/Projection} *)

val from
  :  (module Yocaml.Metadata.VALIDABLE with type t = 'a)
  -> 'a
  -> t Yocaml.Validate.t

val inject : (module Yocaml.Key_value.DESCRIBABLE with type t = 'a) -> t -> 'a
