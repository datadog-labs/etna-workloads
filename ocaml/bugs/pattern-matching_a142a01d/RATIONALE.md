# Rationale
One hunk, ocaml/lambda/matching.ml, `as_interval_canfail`'s `init_rec`: `| [] -> [ (low, high, 0) ]` changed back to `| [] -> []`.
Reverses fix.diff hunk `@@ -2095,7 +2095,7 @@ let as_interval_canfail fail low high l =` (`| [] -> [low,high,0]` -> `| [] -> []`).
The other fix hunks (debug comments/eprintf) are not behavioural; the asserts in switch.ml were left in place, so the empty case array now trips the assertion (PR#6674 compile failure).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result: tests/basic/patmatch.ml fails ("Assertion failed" in lambda/switch.ml).
