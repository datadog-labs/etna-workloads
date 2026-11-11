Reverted fix for #8769 (-pack assertion failure), re-expressed on current code:
- lambda/translmod.ml: `get_field` in apply_coercion (Tcoerce_structure) no longer returns lambda_unit for pos < 0; it always emits Pfield. Reverses hunk `@@ -72,7 +72,10 @@ let rec apply_coercion`.
- bytecomp/bytepackager.ml: removed `Simplif.simplify_lambda` after Translmod.transl_package. Reverses `@@ -195,6 +195,7 @@ let build_global_target`.
- asmcomp/asmpackager.ml: removed both `Simplif.simplify_lambda code` calls. Reverses hunks `@@ -105,6 +105,7 @@` and `@@ -119,6 +120,7 @@ make_package_object`.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh -> tests/regression/pr8769/pr8769.ml fails (ocamlopt -pack exits 2). Final make clean && make -j8 && make -j8 ocamltest, rerun: still failing.
