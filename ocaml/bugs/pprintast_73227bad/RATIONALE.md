# Rationale
One hunk, in `parsing/pprintast.ml`, function `view_expr` (the `loop` inside the `Pexp_construct "::"` case).
The fix hunk is `@@ -103,11 +103,14 @@ let view_expr x =`. In today's code the `pexp_attributes = []` guards
are patterns, not `when` clauses. I removed the guard on the `[]` tail and on the outer `::` node.
The printer therefore treats attributed list tails as plain list elements and drops their attributes (PR#7506).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tests/parsetree/test.ml fails (bytecode and native). locations_test.ml passes.
