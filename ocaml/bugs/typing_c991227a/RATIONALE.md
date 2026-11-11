# Rationale
Hunk: ocaml/typing/typecore.ml, `NameChoice.lookup_from_type`. For constructors (not record labels), a name that is missing from the expected type now raises `Not_found`. Type-mismatch reporting then takes over, instead of the "no constructor B in type a" error. Record labels still raise `Wrong_name_disambiguation`.
This reverses the fix.diff hunk `@@ -75,8 +75,7 @@` in typing-gadts/test.ml.reference. That hunk changed the expected error from "This pattern matches values of type b but a pattern was expected..." to "The variant type a has no constructor B". The other hunks in fix.diff only move or add tests.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: typing-gadts/test.ml fails, and the other two tests pass.
