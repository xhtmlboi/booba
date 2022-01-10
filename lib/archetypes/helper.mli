(** Various helper for archetypes definition. *)

(** {1 Dealing with metadata} *)

val trim_lowercase : string -> string
val map_tags : string list -> string list

(** {1 Pretty-printer helper} *)

(** Existential for hidding pp details*)
type ex_pp

(** Define a pretty printer for key of a record. *)
val pp_field : string -> 'a -> (Format.formatter -> 'a -> unit) -> ex_pp

(** Generic pretty printer for record. *)
val pp_record : string -> Format.formatter -> ex_pp list -> unit

(** Print a quoted string. *)
val pp_quoted_string : Format.formatter -> string -> unit
