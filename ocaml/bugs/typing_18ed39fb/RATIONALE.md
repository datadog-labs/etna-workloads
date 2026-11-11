# Rationale
Hunk in ocaml/typing/env.ml (`prefix_idents`, cases `SigL_class` and `SigL_class_type`): removed
`Subst.add_type id p prefixing_sub` so classes/class types are no longer registered in the prefixing
substitution (and the "pretend this is a type, cf. PR#6650" comment). Reverses fix.diff hunks
`@@ -1147,12 +1147,15 @@ let rec prefix_idents root pos sub = function` (typing/env.ml).
The subst.ml hunk (`@@ -333,8 +333,11 @@ let rec rename_bound_idents`) was not reversed; the env.ml part alone reintroduces the bug.
Tests: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/typing-modules/printing.ml fails (output differs from reference).
