# Rationale
All edits are in ocaml/typing/typeclass.ml; they remove the `Ctype.add_dummy_method` calls that the fix (hunks in typing/typeclass.ml) added, in all three places:
1. `class_type_aux`, `Pcty_constr` case — reverses `@@ -549,13 +549,19 @@ and class_type_aux env scty` (dummy method unify on class type constr).
2. `class_expr_aux`, `Pcl_constr` case — reverses `@@ -1284,6 +1290,12 @@ and class_expr_aux`.
3. `class_expr_aux`, `Pcl_constraint` case — reverses `@@ -1573,9 +1585,16 @@`; also restores `cl_type = snd (Ctype.instance_class [] clty.cltyp_type)` instead of the `ty` binding.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: pr3968_bad.ml passed; Tests.ml and dummy.ml failed.
