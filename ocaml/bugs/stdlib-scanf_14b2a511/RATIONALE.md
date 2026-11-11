# Rationale
One hunk, in `ocaml/stdlib/scanf.ml`. It reverses the fix.diff hunk `@@ -1125,6 +1125,12 @@ fun ib fmt readers -> match fmt with`.
I removed the two `String (pad, Formatting_gen (Open_tag ...))` and `String (pad, Formatting_gen (Open_box ...))` cases from `make_scanf`. Without them, `%s@{` and `%s@[` fall through to the generic `String` case, which scans with no stopper character. That is the PR#6791 regression.

Commands run:
- `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
- Result: `lib-scanf/tscanf.ml` fails. The other tests pass.

RESULT: injected
