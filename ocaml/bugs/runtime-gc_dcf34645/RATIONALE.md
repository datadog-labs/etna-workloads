# Rationale
Changed ocaml/runtime/alloc.c, three hunks (caml_alloc, caml_alloc_string, caml_alloc_float_array large-block paths):
`caml_check_urgent_gc (result)` -> `caml_process_pending_actions_with_root (result)`.
This reverses the fix hunks `@@ -52,7 +53,7 @@ caml_alloc`, `@@ -102,7 +103,7 @@ caml_alloc_string`, `@@ -174,7 +175,7 @@ caml_alloc_float_array`, which replaced the callback-running check with `caml_check_gc_without_async_callbacks`. In today's code the equivalent non-callback function is `caml_check_urgent_gc`; the buggy version runs finalisers/async callbacks from C allocation.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/c-api/alloc_async.ml fails (output differs from reference). Final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh repeated: still failing.
