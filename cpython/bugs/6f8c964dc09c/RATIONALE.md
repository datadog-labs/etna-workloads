# Rationale (gh-149342)

Changes, all in `tree/Modules/_remote_debugging/binary_io_writer.c`:

1. `writer_get_or_create_thread_entry`: `PyMem_Calloc(cap, sizeof(uint32_t))` -> `PyMem_Malloc(cap * sizeof(uint32_t))`.
   Reverses the fix's first hunk (prev_stack no longer zero-initialized).
2. `process_thread_sample`: restored `int is_new_thread` and passed `&is_new_thread` to
   `writer_get_or_create_thread_entry`. Reverses the second hunk.
3. `process_thread_sample`: condition restored to `encoding == STACK_REPEAT && !is_new_thread`
   (and the explanatory comment dropped). Reverses the third hunk. A fresh thread with an
   empty stack compares as STACK_REPEAT, skips RLE buffering, and falls into
   `write_sample_with_encoding`, which has no STACK_REPEAT handler.

The `module.c` hunks (finalize_and_cache ordering, `__exit__`, getter signature) are already
in the fixed form in v3.15.2 (with extra broken-state handling), so they were left alone.

## Oracle failures
`test_writer_handles_empty_stack_first_sample` and
`test_writer_handles_mixed_empty_and_real_first_sample` fail with
`RuntimeError: Invalid stack encoding type`. `test_collector_finalizes_after_external_exception`
and `test_finalize_failure_breaks_writer` also fail, from the same error.
