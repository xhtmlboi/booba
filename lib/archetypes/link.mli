(** Description of links (a pair of name and url) useful for enriching
    metadata. *)

(** {1 Types} *)

type name = string
type url = string

(** The type describing the pair of a name and a URL. *)
type t = private
  { name : name
  ; url : url
  }

(** {1 Helpers} *)

val make : name -> url -> t
val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit

(** {1 Injection/Projection} *)

val from
  :  (module Yocaml.Metadata.VALIDABLE with type t = 'a)
  -> 'a
  -> t Yocaml.Validate.t

val inject : (module Yocaml.Key_value.DESCRIBABLE with type t = 'a) -> t -> 'a
