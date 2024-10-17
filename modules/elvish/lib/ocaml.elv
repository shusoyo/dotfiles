#!/bin/elvish

# Prefix of the current opam switch
set-env OPAM_SWITCH_PREFIX /Users/epoche/.local/share/opam/default
# Updated by package ocaml-base-compiler
set-env CAML_LD_LIBRARY_PATH /Users/epoche/.local/share/opam/default/lib/stublibs
# Updated by package ocaml
set-env CAML_LD_LIBRARY_PATH /Users/epoche/.local/share/opam/default/lib/ocaml/stublibs:/Users/epoche/.local/share/opam/default/lib/ocaml
# Updated by package ocaml
set-env CAML_LD_LIBRARY_PATH /Users/epoche/.local/share/opam/default/lib/stublibs:"$CAML_LD_LIBRARY_PATH"
# Updated by package ocaml
set-env OCAML_TOPLEVEL_PATH /Users/epoche/.local/share/opam/default/lib/toplevel
# Binary dir for opam switch default
set paths =  (conj $paths /Users/epoche/.local/share/opam/default/bin)
