# Rationale
Hunk: ocaml/typing/typetexp.ml, `Ptyp_class` case in `transl_type`: the lookup is now
`Env.find_cltype_by_name lid.txt env` (non-error-reporting lookup, raises raw `Not_found`)
instead of `Env.lookup_cltype ~loc:lid.loc lid.txt env`.
Reverses fix.diff hunk `@@ -398,7 +398,7 @@ let rec transl_type env policy styp` (typetexp.ml), which made
an unbound `#M.foo` report a proper error ("Unbound module M") rather than leak Not_found.
Today's code has no Not_found handler, so the bug is re-expressed by using the errors:false lookup.

Commands: `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`
Result: tests/typing-objects/pr6383.ml fails (Uncaught exception: Not_found).
