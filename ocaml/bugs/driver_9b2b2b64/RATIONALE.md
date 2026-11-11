# Rationale
Fix: PR#7460 – catch Arg.Bad from Compenv.process_deferred_actions in the drivers.
Today's code lives in driver/maindriver.ml and driver/optmaindriver.ml (formerly main.ml / optmain.ml).

Hunks:
- ocaml/driver/maindriver.ml: removed `try ... with Arg.Bad msg -> prerr_endline; print_arguments; exit 2` around `Compenv.process_deferred_actions` (reverses `@@ -129,12 +129,20 @@ let main () =` in driver/main.ml).
- ocaml/driver/optmaindriver.ml: same removal (reverses `@@ -236,15 +236,24 @@ let main () =` in driver/optmain.ml).
(The `spec` refactor in optmain and Changes/tests are not relevant.)

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh.
Result: tests/tool-command-line/test-unknown-file.ml fails (uncaught Stdlib.Arg.Bad exception instead of the message); 5 "failed" lines total (same test and its sub-steps).
