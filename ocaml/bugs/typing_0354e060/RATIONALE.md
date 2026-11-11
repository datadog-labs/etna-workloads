# Rationale
All hunks in ocaml/typing/typedecl.ml, reversing the fix's `typing/typedecl.ml` hunks:
- `@@ -781,7 +781,7 @@ check_well_founded`: removed `~abs_env` param; cyclic-error `Recursive_abbrev`/`Cycle_in_def` again carry `env` (the temporary recursive env) instead of `abs_env`.
- `@@ -843,11 +843,11 @@ check_well_founded_manifest` and `@@ -865,7 +865,7 @@ check_well_founded_decl`: removed `~abs_env` param and forwarding.
- `@@ -1124,24 +1124,25 @@ transl_type_decl`: callers no longer pass `~abs_env` to those functions (abs_env still used by check_abbrev_regularity).
- check_recmod_typedecl: call of check_well_founded_decl no longer passes `~abs_env`.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: typing-short-paths/errors.ml fails (output diff on the cyclic-definition error message: `"B.t" = "B.t"` instead of `"B.t" = "A.t"`).
