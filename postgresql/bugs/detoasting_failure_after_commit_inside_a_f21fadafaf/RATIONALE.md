# Rationale

## src/pl/plpgsql/src/pl_exec.c, exec_for_query()
Traces to the pl_exec.c hunk of fix_impl.patch. Removed the block that sets
`prefetch_ok = false` when `!estate->atomic`. Without it, a FOR loop in a
non-atomic context (procedure with COMMIT) prefetches up to 10 rows, including
toasted values. After COMMIT in the loop body, those toast pointers dangle and
detoasting fails.

The toast_internals.c hunk only changed an error message text, so it was not reverted.

## Failing oracle cases
- src/test/isolation||plpgsql-toast
