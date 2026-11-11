# Rationale
One hunk, ocaml/typing/typecore.ml (type_application, commuted-argument branch of `extract_label`):
replaced `Location.prerr_warning ... (Warnings.Nonoptional_label ...)` by
`raise(Error(sarg.pexp_loc, env, Apply_wrong_label(l', ty_fun', optional)))`.
Reverses fix.diff hunk `@@ -2952,10 +2952,11 @@ and type_application env funct sargs`
(which turned the Apply_wrong_label error into warning 43). Warning 43 definitions and the typeclass.ml hunk were left
(the warning type still exists; typeclass path was not changed to keep it minimal).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-misc/labels.ml failed (expects warning 43, got Error).
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: labels.ml fails.
