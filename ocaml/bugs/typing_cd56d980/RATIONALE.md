# Rationale
Hunk: ocaml/typing/typetexp.ml, `Ptyp_class` case in `transl_type_aux`.
Today's code only calls `Env.lookup_cltype`. I changed it so that when the cltype lookup fails, it calls `Env.lookup_class` (then `assert false`). The error then reads "Unbound class bar" instead of "Unbound class type bar".
This reverses fix.diff hunk `@@ -279,7 +279,7 @@ and transl_type_aux env policy styp =` in typing/typetexp.ml. That hunk changed `lookup_class` to `lookup_cltype` in the fallback.
The test-file hunk in fix.diff was not touched.

Commands run: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: precise_locations.ml => failed, as expected.
