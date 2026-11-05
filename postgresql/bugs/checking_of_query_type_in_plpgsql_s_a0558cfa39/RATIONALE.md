# Reintroduced bug: RETURN QUERY query-type check

Changed file: `src/pl/plpgsql/src/pl_exec.c`, function `exec_stmt_return_query`.

Both hunks trace to the `pl_exec.c` part of fix_impl.patch.

1. **RETURN QUERY (prepared plan branch).**
   - The fix added `options.must_return_tuples = true` and replaced the post-execution `rc != SPI_OK_SELECT` check with `if (rc < 0) elog(...)`.
   - I removed the option and restored the old `rc != SPI_OK_SELECT` check, including the "query is SELECT INTO..." and "query is not a SELECT" errors.
2. **RETURN QUERY EXECUTE branch.** Same change as hunk 1.

The old check only runs after the query has already executed. The query-type error therefore comes too late, and the messages differ from the ones the fix introduced.

I left the `spi.c` and `spi.h` support for `must_return_tuples` in place. Nothing in plpgsql sets it any more, so the SPI-side check is never used.

## Failing oracle case
- `src/test/regress||plpgsql`
