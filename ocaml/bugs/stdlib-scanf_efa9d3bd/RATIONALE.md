# Rationale
One hunk, ocaml/stdlib/scanf.ml (make_scanf): removed the two cases
`String (pad, Formatting_gen (Open_tag ...))` and `... (Open_box ...)` (stop chars '{' and '[').
Reverses fix.diff hunk `@@ -1125,6 +1125,12 @@ fun ib fmt readers -> match fmt with` in stdlib/scanf.ml.
Without them "%s@{" / "%s@[" scan with no stopper (PR#6791 regression).
(The test hunk and Changes are not reverted.)

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/lib-scanf/tscanf.ml fails (bytecode and native).
