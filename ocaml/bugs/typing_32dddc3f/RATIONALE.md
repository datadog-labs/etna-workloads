# Rationale
Both edits are in ocaml/typing/ctype.ml and reverse fix.diff's hunks of typing/ctype.ml
(`@@ -2169,6 +2169,19 @@ add_type_equality` which added normalize_package_path/eq_package_path, and the
Tpackage hunks in unify3/moregen/eqtype/subtype_rec that use eq_package_path instead of Path.same).
In today's code those are all routed through `eq_package_path` and `compare_package`:
1. `eq_package_path` no longer normalizes module-type aliases (`Env.normalize_modtype_path`); only direct path equivalence.
2. `compare_package` no longer falls back to `package_subtype` (module-type inclusion, which today would
   mask the missing alias handling); non-equal paths yield an Error, as with the old `Path.same` check.
Result: `(module S1)` vs `(module S2)` with `module type S2 = S1` is rejected.
Commands: `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`:
tests/typing-fstclassmod/fstclassmod.ml => failed (passed with only edit 1, hence edit 2).
