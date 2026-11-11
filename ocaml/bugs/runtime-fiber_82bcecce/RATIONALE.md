# Rationale
Reverts fix #11105 (stack cache bucket index -> pointer to bucket), re-expressed in current code.
- runtime/caml/fiber.h `@@ -50,12 +50,12 @@ struct stack_info`: `int cache_bucket` back to `struct stack_info** size_bucket` (and comment).
- runtime/fiber.c `@@ -98,36 +98,44 @@ stack_cache_bucket`: returns pointer into the current domain's Caml_state->stack_cache instead of an index.
- runtime/fiber.c `alloc_size_class_stack_noexc` hunks (`@@ -136,7`, `@@ -164,15`, caml_alloc_stack hunks `@@ -294,7`): use size_bucket pointer; callers pass Caml_state->stack_cache.
- runtime/fiber.c `@@ -467,10 +476,14 @@ caml_free_stack`: frees into `*stack->size_bucket`, i.e. the allocating domain's cache, even from another domain.
Changes entry/blank-line hunks not reproduced.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` (the clean build was cut by a tool timeout, then `make -j8 && make -j8 ocamltest` completed the build, exit 0). Result: tests/parallel/test_issue_11094 fails (run action; debug-runtime assertion stack->size_bucket == stack_cache_bucket(wosize) in runtime/fiber.c).
