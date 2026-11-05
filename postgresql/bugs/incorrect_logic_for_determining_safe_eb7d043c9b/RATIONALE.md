# Rationale

## src/backend/optimizer/path/allpaths.c, find_window_run_conditions()
Traces to the fix.patch hunk adding, after the `IsA(wfunc, WindowFunc)` check:

    /* can't use it if there are subplans in the WindowFunc */
    if (contain_subplans((Node *) wfunc)) return false;

I removed that check. A window function containing a subplan can then be used
as a WindowAgg run condition, which is the unsafe logic the fix removed.

The other hunks of fix_impl.patch (the unsafeFlags refactor and the
PUSHDOWN_WINDOWCLAUSE_RUNCOND handling) are still in the code unchanged. I did
not revert them.

## Oracle cases expected to fail
- src/test/regress||window

Confirmed: the oracle reports FAIL for src/test/regress||window with this change.
