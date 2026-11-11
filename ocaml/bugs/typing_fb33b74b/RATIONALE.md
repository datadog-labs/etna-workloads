# Rationale
File: ocaml/typing/ctype.ml (unify_row / unify_row_field). Reverses the fix hunks
`@@ -2901,7 +2901,7 @@ and unify_row env row1 row2`, `@@ -2914,7 +2914,7 @@ ... unify_row_field`, and the level-handling hunks
(`@@ -2972,13 +2972,18 @@`, `@@ -2988,7 +2993,7 @@`, `@@ -2997,7 +3002,7 @@`):
unify_row_field takes the single merged `more` row variable again (instead of rm1/rm2), and
levels/scopes of the leftover types and of the present-arg type are updated against `more`
rather than the row variable of the opposite row. The tl1'/tl2' swap in the fix is a
naming-only change in today's code and left alone.
Commands: make -j8 && make -j8 ocamltest; sh run-oracle.sh -> typing-gadts/or_patterns.ml fails
(expect output differs). Final make clean + rebuild + oracle rerun also showed failure.
