# Rationale
Hunk: ocaml/stdlib/set.ml, `Set.map`: final `else try_join l' v' r'` changed to `else join l' v' r'`.
Reverses fix.diff hunk `@@ -406,12 +415,7 @@` in stdlib/set.ml (map now uses try_join instead of unchecked join), PR#7403. try_join is still used by filter_map.
Map with an order-changing function now builds an ill-ordered set.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/lib-set/testset.ml fails (testset.byte exit code 2, assertion).
