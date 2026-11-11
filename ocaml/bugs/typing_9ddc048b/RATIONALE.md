# Rationale
All changes in ocaml/typing/ctype.ml, re-adding `equations_generation` (reverse of fix "Fix #13579 by removing equations_generation"):
- type `equations_generation` + `Pattern.equations_generation` field (hunks `@@ -349,10 +349,6 @@`, `@@ -360,7 +356,7 @@`), `can_generate_equations`, `record_equation` matching Forbidden (`@@ -407,16 +403,12 @@`), `without_generating_equations` (`@@ -438,11 +430,6 @@`).
- `unify3_var` guards equation recording by `can_generate_equations` (`@@ -2694,10 +2681,8 @@`).
- `unify3` Tconstr/Tconstr case: non-injective params are unified with equation generation forbidden instead of being reified, plus the `can_generate_equations` guards in the other cases and Tvariant (`@@ -2856,7 +2841,7 @@` through `@@ -2934,10 +2910,8 @@`).
- `unify_gadt` builds `Allowed {equated_types}` (`@@ -3285,10 +3259,9 @@`).
Tests/Changes hunks of fix.diff not touched.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr13579.ml fails (accepts unsound `Equal`, different error messages).
