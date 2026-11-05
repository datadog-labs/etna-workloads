# Rationale

## Changed hunk
- File/function: `src/pl/plpgsql/src/pl_handler.c`, `plpgsql_inline_handler()`, in the `PG_CATCH()` block.
- Removed the `plpgsql_subxact_cb(SUBXACT_EVENT_ABORT_SUB, GetCurrentSubTransactionId(), 0, NULL);` call.
- Traces to the `pl_handler.c` hunk of fix.patch, which added that call (and the rest of the PG_TRY cleanup) to the error path of the DO-block handler.
- Why this brings the bug back: the error path frees the private EState without first cleaning up the `simple_econtext_stack` entries that point into it. Those entries then dangle. A later subxact abort in an outer block (the regression test's `exception when division_by_zero`) walks the stale entries and touches freed memory, so the cleanup that the fix added is missing again.

## Not done
- I did not restore the shared-EState behaviour that the fix replaced, because today's code already has the private-EState design. The bug is re-expressed only through the missing error-path cleanup.
- My first attempt removed the whole error-path cleanup (not just this call), and the oracle still passed, so I dropped it.

## Failing oracle cases
- `src/test/regress||plpgsql`
