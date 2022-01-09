(** Description of a Page. *)

(** {1 Types} *)

(** The type describing a page. *)
type t = private
  { page_title : string option
  ; page_desc : string option
  ; page_authors : Human.t list
  ; page_tags : string list
  }

(** {1 Helpers} *)

val make : string option -> string option -> Human.t list -> string list -> t
val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit

(** {1 Injection/Projection} *)

val from
  :  (module Yocaml.Metadata.VALIDABLE with type t = 'a)
  -> 'a
  -> t Yocaml.Validate.t

val inject : (module Yocaml.Key_value.DESCRIBABLE with type t = 'a) -> t -> 'a
