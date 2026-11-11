# Rationale
All changes in ocaml/typing/typedecl.ml, reversing fix.diff (fix 13501):
- `enter_type`: `Ctype.newvar ()` -> `Btype.newgenvar ()` (reverses hunk `@@ -119,7 +119,7 @@ enter_type`).
- Removed `update_type` function (reverses `@@ -1054,6 +1054,20 @@ check_redefined_unit`).
- `transl_type_decl`: `temp_env` no longer returned from the generalize block (reverses `@@ -1092,7 ...` and `@@ -1139,7 ...`).
- Removed the "Update temporary definitions" block after check_abbrev_regularity (reverses `@@ -1169,6 +1183,15 @@`).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> constraints.ml fails (vanishing constraint no longer checked). Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: constraints.ml still fails.
