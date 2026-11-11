# Rationale
Hunk: ocaml/runtime/globroots.c, `caml_modify_generational_global_root`, YOUNG case:
`if(c != YOUNG)` -> `if(c == UNTRACKED)` before inserting into `caml_global_roots_young`.
Reverses fix.diff hunk `@@ -229,39 +259,31 @@ CAMLexport void caml_modify_generational_global_root(value *r, value newval)`.
The fix made a root be (re)inserted into the young list whenever the new value is young and the old class
wasn't young. With this change, a root whose old value was OLD/static and whose new value is young is
removed from the old list but not inserted in the young list, so the GC does not scan it.

Commands: `make clean && make -j8 && make -j8 ocamltest` (the clean build hit the tool timeout; I reran `make -j8 && make -j8 ocamltest`, which succeeded), then `sh run-oracle.sh`.
Results: globroots, globroots_parallel and globroots_parallel_spawn_burn pass. globroots_sequential fails in bytecode and native (Assertion failed, globroots_sequential.ml line 57).
