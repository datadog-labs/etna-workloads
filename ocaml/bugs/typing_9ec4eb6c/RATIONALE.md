# Rationale
File: ocaml/typing/typecore.ml, `type_statement`. Moved the Nonreturning_statement warning check from before the
`if !Clflags.strict_sequence` test into the non-strict `else` branch, so -strict-sequence no longer emits Warning 21.
Reverses fix.diff hunk `@@ -3739,24 +3739,26 @@ and type_statement env sexp =` (which hoisted the warning above the strict_sequence test).
Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh` -> tests/typing-warnings/pr7297.ml fails (missing Warning 21).
