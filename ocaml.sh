#!/bin/bash

# It's already in the shell file copied from dotfile
opam init -n
eval $(opam env)
opam switch create 4.10.0
eval $(opam env)

opam install -y \
    utop core async \
    merlin ocamlformat \
    ocaml-lsp-server

