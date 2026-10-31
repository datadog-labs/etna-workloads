# gh-116767 reintroduced

Fix hunks reversed:

1. `Python/compile.c` `compiler_function_body` (push/pop of the new `STOP_ITERATION` fblock around the body of generator/coroutine functions) -> in v3.15.2 this lives in `Python/codegen.c` `codegen_add_body`-style helper (the code around `add_stopiteration_handler`). I removed the `NEW_JUMP_TARGET_LABEL/USE_LABEL(start)`, the `_PyCompile_PushFBlock(..., COMPILE_FBLOCK_STOP_ITERATION, ...)` and the matching `_PyCompile_PopFBlock`. The compiler again does not count the block that `codegen_wrap_in_stopiteration_handler` pushes in the exception table, so `async with` with many managers overflows the handler stack.
   The enum value and the `compiler_unwind_fblock` case are left in place (now unused, harmless).
2. `Include/cpython/code.h`: `CO_MAXBLOCKS` 21 -> 20, as before the fix.

Oracle: the build is run with the oracle; test_syntax crashes/asserts (incomplete run, 107 of 109 cases reported failing), notably `test_async_with_statement_many_context_managers`, which compiles an `async with` with ~20 managers in an async generator; the flowgraph handler stack (`stack->depth <= CO_MAXBLOCKS` assert) is exceeded, as in the original crash. The other cases fail because the process aborts.
