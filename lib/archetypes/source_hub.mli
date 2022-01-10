(** Description of a Version Source . *)

(** {1 Types} *)

type t

(** {1 Helpers} *)

val make : string -> string -> string -> t Yocaml.Validate.t
val equal : t -> t -> bool
val dmp : Format.formatter -> t -> unit

(** {1 Links} *)

val edit : t -> Yocaml.Filepath.t -> string
val blob : t -> Yocaml.Filepath.t -> string
val tree : t -> Yocaml.Filepath.t -> string

(** {1 Injection/Projection} *)

val from
  :  (module Yocaml.Metadata.VALIDABLE with type t = 'a)
  -> 'a
  -> t Yocaml.Validate.t

val inject : (module Yocaml.Key_value.DESCRIBABLE with type t = 'a) -> t -> 'a
