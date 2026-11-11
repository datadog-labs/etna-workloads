# Rationale
File: ocaml/typing/subst.ml. Reverses fix.diff hunks in typing/subst.ml:
- `@@ -118,6 +118,12 @@ let type_path` : removed helper `to_subst_by_type_function`.
- `@@ -191,7 +197,9 @@ let rec typexp` : Tobject name always `Some (type_path s p, ...)`.
- `@@ -223,8 +231,11 @@` : Tvariant row_name always `Some (type_path s p, tl)`.
Result: substituting a type-function-substituted name hits `assert false` in type_path (sigsubst.ml test fails).
Ran: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> sigsubst.ml failed.
