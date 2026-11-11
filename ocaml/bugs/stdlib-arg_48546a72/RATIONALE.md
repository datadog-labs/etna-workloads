# Rationale
Hunk: ocaml/stdlib/arg.ml, in parse_and_expand_argv_dynamic_aux's loop.
Fix hunk reversed: `@@ -144,43 +148,43 @@ let parse_and_expand_argv_dynamic_aux ...` (and the later `@@ -253,15 +257,12 @@`),
which made internal Stop errors be converted once, outside the handler for user Bad.
Now Stop e is converted to Bad (with usage) in an inner try, and the outer `with Bad m` re-wraps it
as Message, so the usage message is repeated.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: lib-arg/testerror.ml fails (output differs from reference).
