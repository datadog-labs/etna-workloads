# Rationale
One hunk, typing/ctype.ml, `copy_sep` (inner `copy_rec`): non-static polymorphic variant nodes are no longer
registered in the sharing table (`visited`), so a variant occurring multiple times in a polymorphic method type
is copied separately and loses its sharing. This reverses the fix hunks
`@@ -1315,6 +1315,7 @@ let delayed_copy` ... `~(shared : type_expr TypeHash.t)` and
`@@ -1341,10 +1344,11 @@` (`if not (static_row row) then TypeHash.add shared ty t;`),
re-expressed for today's code where the single `visited` table plays the role of `shared`.
Tests: `make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`: pr10664a.ml fails. Final `make clean` rebuild repeated, same result.
