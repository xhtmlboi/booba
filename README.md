# booba
A turnkey static blog generator based on [YOCaml](https://github.com/xhtmlboi/yocaml)

> After paying tribute to [Hugo](https://gohugo.io/) and
> [Zola](https://www.getzola.org/), the great family of static blog generators
> pays tribute to another great poet of the 21st Century. Often compared to
> Céline, and I quote, "_if you ignore the form_".

## Setup

Even though the purpose of **booba** is to provide a binary buried in a file
tree, its installation is relatively simple for someone who is familiar with the
OCaml ecosystem.

One approach is to use a local swtich to locate all dependencies in the `_opam`
directory at the root of the project.

### Building with OPAM by hand

``` shellsession
# opam switch create . ocaml-base-compiler.4.13. -y
# opam install . --deps-only --with-doc --with-test -y
# opam install yocaml -y
# opam install yocaml_unix yocaml_yaml yocaml_markdown yocaml_jingoo -y
```

And if you want to modify the source code, here is what I personally use:

``` shellsession
# opam install dune merlin ocamlformat ocp-indent -y
```

When this is done, you can simply test that the project compiles by running
`dune build`.

### Using `make`

Essentially out of laziness, the project comes with a `Makefile` which has two,
among others, rules `make deps` and `make dev-deps` (`dev-deps` will install
`merlin`, `dune`, `ocamlformat` and `ocp-indent`), It is therefore possible to
reproduce the previous session in this way:

``` shellsession
# opam switch create . ocaml-base-compiler.4.13. -y
# make deps
# make dev-deps
```

