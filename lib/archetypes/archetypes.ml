(** {1 Archetypes}

    Describes items that need to be analysed or injected. *)

module Config = Config
module Page = Page

(** {1 Components}

    Components used in the representation of archetypes (fragments of models
    that do not need to be represented in a "total" way, attached to pages). *)

module Link = Link
module Human = Human
module Source_hub = Source_hub

(** {1 Misc}

    Utility functions to assist the implementation of archetypes and different
    models. *)

module Helper = Helper
