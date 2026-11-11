# Rationale
One hunk, ocaml/typing/typecore.ml, `type_statement`: the Nonreturning_statement warning check was moved
inside the non-strict-sequence `else` branch, so with -strict-sequence `raise Exit; ()` no longer warns.
Reverses fix.diff hunk `@@ -3756,24 +3756,26 @@ and type_statement env sexp =` (which hoisted the warning before the
`if !Clflags.strict_sequence` test). The fix's Makefile/test hunks are test-only and untouched.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
pr7297.ml => failed (expected warning 21 missing).
