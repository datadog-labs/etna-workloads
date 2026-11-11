# Rationale
File: ocaml/otherlibs/dynlink/dynlink_common.ml. Removed `init ();` from `main_program_units`, `public_dynamically_loaded_units` and `all_units`.
Reverses the fix hunk `@@ -316,12 +316,15 @@ module Make (P : Dynlink_platform_intf.S)` (which added those calls). The Changes and test hunks were not touched.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result: tests/lib-dynlink-init-info/test.ml fails (assert, exit code 2).
