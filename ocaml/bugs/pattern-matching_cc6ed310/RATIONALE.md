# Rationale
Hunk 1: ocaml/typing/parmatch.ml, `should_extend`: removed `Cstr_unboxed` from the tags checked against the
extensible type path and moved it to the `false` branch next to `Cstr_extension`. Reverses fix.diff hunk
`@@ -654,17 +654,31 @@ let full_match closing env` (the should_extend part that added `Cstr_unboxed`).
Effect: matches on [@@unboxed] constructors are wrongly reported as fragile (warning 4), PR7451.

Hunk 2 (collateral, build only): ocaml/utils/profile.ml line 16, warning spec `+a-18-...` -> `+a-4-18-...`.
profile.ml has an unboxed constructor matched under `+a` with warn-error, so with the bug restored the
compiler can't rebuild itself (opt stage). Not part of the fix; it only keeps the build working.

Commands: `make clean && make -j8 && make -j8 ocamltest` (first clean build failed on profile.ml; after hunk 2 succeeded),
then `sh run-oracle.sh`: tests/warnings/w04.ml => failed (spurious warning 4 on `f`).
