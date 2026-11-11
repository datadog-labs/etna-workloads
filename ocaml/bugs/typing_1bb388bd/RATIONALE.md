# Rationale
Hunk: ocaml/typing/ctype.ml, `moregen_occur`. Re-adds the special case that, for a static polymorphic variant row, only iterates the row fields (`iter_row`) and skips `row_more`, instead of `iter_type_expr` for all types.
Reverses fix.diff hunk `@@ -3196,11 +3196,7 @@ let moregen_occur env level ty =` (the fix removed this case).
Effect: the weak variables inside a static row are not seen by the occur check, so the unsound inclusion in pr7817_bad.ml is accepted.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: pr7817_bad.ml fails (3 "=> failed" lines, all for that test).
