# Rationale
Fix (PR#7460) wrapped `Compenv.process_deferred_actions` in `try ... with Arg.Bad` in the drivers. Reverted in today's code:
- `ocaml/driver/maindriver.ml`: removed `try ... with Arg.Bad msg -> prerr_endline; print_arguments; exit 2` around process_deferred_actions. Reverses hunk `@@ -125,12 +125,20 @@ let main () =` of driver/main.ml.
- `ocaml/driver/optmaindriver.ml`: same removal. Reverses `@@ -231,13 +231,22 @@ let main () =` of driver/optmain.ml.
(The `spec` let-binding was only needed for the handler; not applicable in today's code. Changes/test hunks untouched.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/tool-command-line/test-unknown-file.ml fails (uncaught Arg.Bad).
