# Rationale
One hunk: ocaml/typing/typedecl_unboxed.ml, get_unboxed_type_representation.
Replaced `Ctype.maybe_instance_poly ty2` with `match get_desc ty2 with Tpoly (t, _) -> t | _ -> ty2`
(strips Tpoly without instantiating univars). Reverses fix.diff hunk
`@@ -31,7 +31,7 @@ let rec get_unboxed_type_representation env ty fuel =`.
(Other fix hunks left in place; this one alone reintroduces the Ctype.Cannot_apply failure.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: pr14603.ml fails with "Uncaught exception: Ctype.Cannot_apply".
