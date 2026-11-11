# Rationale
Edited ocaml/typing/datarepr.ml: in `constructor_args`, the inline record's `type_private` is set to `Public` again (instead of the `priv` parameter). The parameter is renamed `_priv` and stays, so callers are unchanged.
This reverses the fix.diff hunks `@@ -49,7 +49,7 @@ constructor_args`, `@@ -73,7 +73,7 @@` (type_private = priv), and, in effect, the two call-site hunks (`@@ -111` and `@@ -141`), whose arguments are now ignored.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. Result: pr7228.ml fails (the mutation of a private inline record is accepted).
