.PHONY: all build clean fmt deps dev-deps utop

all: build

build:
	dune build

clean:
	dune clean

fmt:
	dune build @fmt --auto-promote

dev-deps:
	opam install dune merlin ocamlformat ocp-indent -y

deps:
	opam install . --deps-only --with-doc --with-test -y
	opam install yocaml -y
	opam install yocaml_unix yocaml_yaml yocaml_markdown yocaml_jingoo -y

doc:
	dune build @doc

utop: build
	dune utop
