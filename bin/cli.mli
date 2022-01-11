type common_option =
  { theme : string option
  ; target : string option
  ; subfolder : string option
  ; config : string option
  }

val build
  :  (common_option -> unit)
  -> unit Cmdliner.Term.t * Cmdliner.Term.info

val watch
  :  (common_option -> int option -> unit)
  -> unit Cmdliner.Term.t * Cmdliner.Term.info

val program : unit Cmdliner.Term.t * Cmdliner.Term.info
