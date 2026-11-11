# Rationale
File: ocaml/lambda/value_rec_compiler.ml. Reverses fix.diff hunks:
- `@@ -126,6 +126,39 @@ join_sizes`: removed `find_size_of_alloc_prim`.
- `@@ -266,6 +299,12 @@ compute_static_size`: removed the `Pccall prim` case returning `Block size`.
- `@@ -277,7 +316,6 @@`: restored `Pccall _` to the dynamic-size primitive list.
- `@@ -726,6 +764,8 @@ compile_alloc`: removed the comment mentioning the function.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`; letrec-compilation/nested2.ml fails (ocamlc exit 2).
