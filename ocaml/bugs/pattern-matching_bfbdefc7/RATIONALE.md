# Rationale

One hunk, in `ocaml/typing/parmatch.ml`: `pats_of_type` is restored to its pre-fix form. It calls `Ctype.expand_head` and matches on `Tconstr`, `Ttuple` or anything else. It no longer uses `Ctype.extract_concrete_typedecl`. This reverses the fix hunk `@@ -824,11 +824,9 @@ let pat_of_constrs ex_pat cstrs =` (the `pats_of_type` part) and the second part of that hunk, `@@ -840,24 +838,24 @@`.

It is re-expressed in today's code. The tuple case keeps the labelled-tuple form `(lbl, omega)`. `Type_abstract _` and `Type_external _` match the current constructors.

I did not revert the `get_variant_constructors` change. The bug shows up without it.

Effect: a GADT re-exported through a module whose original cmi is missing is no longer refutable. `tests/typing-missing-cmi-3/user.ml` now reports "This match case could not be refuted".

## Commands run
`make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. The build succeeded, and `typing-missing-cmi-3/user.ml` failed (the expect step).
