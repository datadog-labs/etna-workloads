# Rationale
File: ocaml/lambda/translprim.ml, `transl_primitive` (formerly bytecomp/translprim.ml).
Reverses fix.diff hunk `@@ -686,13 +686,13 @@ let transl_primitive loc p env ty path =`, which made zero-parameter primitives
(e.g. __FILE__, __LINE__) return the bare body rather than a `Lfunction` with no params.
Now the Lfunction wrapper is again built for zero-arity location primitives (FILE/LINE/POS/MODULE/FUNCTION),
so they evaluate to a closure instead of the value. Other zero-arity primitives (`%loc_LOC`, `%sys_argv`) are
still unwrapped, because the compiler itself uses __LOC__ and Sys.argv and a fully reverted version crashed the self-build.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
translprim/locs.ml fails (bytecode and native, segfault); all else passes.
