# Rationale
Hunk: ocaml/typing/typecore.ml, `Label.disambiguate` (NameChoice functor), last `exception Not_found` branch.
Replaced `filter (force_error candidates_in_scope)` with a match that does `assert false` on `Error _`
(no candidates in scope), instead of reporting the unbound-name error.
Reverses fix.diff hunks `@@ -599,7 +599,7 @@ end) = struct` / `@@ -638,6 +638,7 @@` in typing/typecore.ml
(`if lbls = [] then unbound_name_error env lid else`): an undefined qualified field (`x.Complex.z` with x : Complex.t)
gives an assert failure instead of "Unbound record field Complex.z" (PR#5865).
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> typing-misc/records.ml failed (output differs).
