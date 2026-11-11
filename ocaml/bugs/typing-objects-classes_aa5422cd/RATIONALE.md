# Rationale
Hunk: ocaml/typing/typeclass.ml, class_structure ("Typing of method bodies"): the call
`Ctype.generalize_class_signature_spine sign` is again guarded by `if !Clflags.principal then`.
Reverses fix.diff hunk `@@ -815,12 +817,16 @@ and class_structure ...` in typing/typeclass.ml (and the
`@@ -1217,7 +1223,7 @@ initial_env` one, whose generalize_spine is now folded into this
unconditional call in today's code), which made spine generalization unconditional (PR#5545).
Today's code has one call site, so one guard restores the bug.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-objects/Tests.ml failed (reference diff), poly.ml passed.
Final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: Tests.ml still fails.
