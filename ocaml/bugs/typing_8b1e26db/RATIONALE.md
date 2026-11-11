# Rationale
File ocaml/typing/includemod.ml, in `Functor_inclusion_diff.diff`:
- the initial state is again `{ env; subst = Subst.identity; res = ... }` and the `i_subst` field of the argument is ignored (`i_subst=_`). This reverses hunks `@@ -1203,7 +1205,8 @@ module Functor_inclusion_diff` and `@@ -1220,7 +1223,7 @@` of fix.diff (the captured substitution of equalities was no longer used when recomputing the inclusion checks for functor error messages).
The rest of the fix's plumbing is left in place (it is inert without this use).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-modules/functors.ml fails (expect output differs: "Type Inner.t is abstract because no corresponding cmi file..."). Final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: functors.ml fails.
