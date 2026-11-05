# Rationale
- File/function: src/backend/commands/analyze.c, acquire_inherited_sample_rows (final `else` branch for partitioned children).
- Traces to the fix.patch hunk in the same function. I removed the `else table_close(childrel, NoLock);` that closes the passed-in relation when it is skipped.
- Effect: when the child is the parent relation itself (partitioned table), its relcache reference is never released. That leaks the reference and produces a relcache reference leak warning.

Failing oracle case: src/test/regress||vacuum
