(** Description of humans. Yeah... "humans" *)

(** {1 Types} *)

type firstname = string
type lastname = string

(** The type describing a... kind of human. *)

type t = private
  { nickname : string
  ; name : (lastname * firstname) option
  ; mail : string option
  ; bio : string option
  ; links : Link.t list
  }

(** {1 Helpers} *)

val make
  :  string
  -> (lastname * firstname) option
  -> string option
  -> string option
  -> Link.t list
  -> t

val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit

(** {1 Injection/Projection} *)

val from
  :  (module Yocaml.Metadata.VALIDABLE with type t = 'a)
  -> 'a
  -> t Yocaml.Validate.t

val inject : (module Yocaml.Key_value.DESCRIBABLE with type t = 'a) -> t -> 'a
