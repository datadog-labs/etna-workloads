# Rationale
One hunk, ocaml/typing/ctype.ml, `local_non_recursive_abbrev`: the default `| _ ->` case no longer
recurses into subterms (`iter_type_expr ...`); it now returns `()`. This reverses the fix hunk
`@@ -1704,15 +1705,9 @@ let rec local_non_recursive_abbrev visited env p ty`, which removed the
`| _ -> () ` (always-rectypes assumption) and restored the structural check. The fix's `Tobject/Tvariant`
removal doesn't map directly to today's code, so only the default case was reverted.
Effect: GADT equations that are recursive (PR#6405) are accepted, so the pr6174.ml expect test output changes.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` then a final `make clean` + rebuild + run-oracle.
Result: pr6174.ml failed; test.ml and Tests.ml passed.
