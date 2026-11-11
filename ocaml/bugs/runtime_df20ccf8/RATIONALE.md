# Rationale
Hunk: ocaml/stdlib/camlinternalMod.ml, `update_mod_field`: the `Function` shape no longer
stores `n` directly; it stores a fresh wrapper closure `fun x -> n x`.
Reverses fix.diff hunk `@@ -51,12 +51,16 @@ let rec update_mod shape o n =`, whose effect was to
avoid always wrapping functions in a forwarding closure (the old `else overwrite o (fun x -> n x)` path).
Today's code has no `overwrite`, so the wrapper is re-expressed via set_field.
Effect: `module rec Id : sig ... end = Id` makes the dummy function forward to a wrapper that
forwards to the dummy: non-terminating loop instead of Undefined_recursive_module (pr9494 hangs).

Commands: `make clean; make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
pr9494 hangs (no "passed"; killed by timeout) => fails.
