# Rationale
One hunk, `ocaml/typing/ctype.ml`, in `reify`'s `create_fresh_constr`.
Today's line `let name = match name with Some s -> "$'"^s | _ -> "$" in` is now
`let name = match name with Some s -> s | _ -> "ex" in`.
It reverses fix.diff hunk `@@ -1940,6 +1943,7 @@ let reify env t =`, which added the `$'`/`$` prefixes.
Reified type variables go back to uninformative names such as `ex1`, instead of `$1` or `$'a`.
The other fix hunks (counter reset, `#` format, constructor-based names) have moved or changed in the current code, so I left them alone.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Then the final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: all 5 oracle tests fail (dynamic_frisch, pr6158, pr6174, pr6690, test.ml), with name differences such as `ex1` where `$1` is expected.
