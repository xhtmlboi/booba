(** The configuration of Booba's default behaviour.*)

(** Defines the default target where to build the website. *)
val default_target : Yocaml.Filepath.t

(** Defines the sub-folder (in [target]) where to create the file. If the site
    is to be created at the root of [target], use [None].

    If the website is to be generated in a subfolder of the target (e.g. the
    target is [_site] but the site is generated in [_site/my_subsite], which
    can be convenient if the site is not to be generated at the root of the
    server (e.g. for a project that is deployed on the [gh-pages] branch
    generating as the address [https://your-nickname.github.io/your-project]
    you can give the target that you want and the subfolder [your-project]. *)
val default_subfolder : Yocaml.Filepath.t option

(** The default port for launching the development server. I have, by default,
    chosen [8084] because it looks a bit like [booba]. Hehe.*)
val default_port : int

(** Defines the theme to be used (by default). A theme is defined in the
    [themes/] directory. *)
val default_theme : string

(** The default configuration file. *)
val default_config_file : Yocaml.Filepath.t
