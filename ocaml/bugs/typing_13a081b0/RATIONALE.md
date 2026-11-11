# Rationale
File: ocaml/typing/ctype.ml, two hunks, reversing fix.diff hunks `@@ -1915,8 +1915,14 @@ occur_univar` and `@@ -1963,8 +1969,8 @@ univars_escape` (today these are in occur_univar_or_unscoped and the escape check around line 2418).
They restore the old variance test `mem May_pos v || mem May_neg v` in place of `not (eq v null)`, so type args with non-null variance but neither pos nor neg (e.g. private abbreviations) are ignored and escaping universal variables go unreported.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> poly.ml fails; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh -> poly.ml still fails.
