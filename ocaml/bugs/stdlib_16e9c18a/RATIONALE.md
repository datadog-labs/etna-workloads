# Rationale
Hunk: ocaml/stdlib/stdlib.ml, `at_exit`: removed the `f_yet_to_run` atomic flag and the
compare-and-set guard, so `f ()` is called unconditionally each time the exit chain runs.
Reverses fix.diff hunk `@@ -538,7 +538,12 @@ let exit_function = ref flush_all` in stdlib/stdlib.ml
(today's code uses an atomic flag instead of a ref). The threads/stdlib.ml hunk no longer exists.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> tests/basic/pr7253.ml fails
(uncaught My_exception, handlers re-run).
