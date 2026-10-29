# Rationale

Fix (CVS 2543, ticket #1315): "only one busy counter". Before it, `sqlite3BtreeBeginTrans`
kept its own local `busy` counter and invoked the handler directly, separate from the
counter used by the pager's lock loop. The fix routed both through `sqlite3InvokeBusyHandler`,
which uses the shared `BusyHandler.nBusy`.

## Change (src/btree.c, `btreeBeginTrans`)
Reverses the `sqlite3BtreeBeginTrans` hunk: re-added the local `int busy = 0; BusyHandler *pH;`
and replaced `btreeInvokeBusyHandler(pBt)` in the retry loop condition with a direct call
`pH->xBusyHandler(pH->pBusyArg, busy++)`. This bypasses the shared `nBusy` counter (and its
"handler returned 0 => nBusy=-1" latch), as in the pre-fix code. The pager path
(`pager_wait_on_lock` equivalent, via `btreeInvokeBusyHandler`) still uses the shared counter,
so there are again two independent counters. The other fix hunks (helper function, nBusy field,
resets) already exist in 3.54.1 and are left alone.

## Oracle failures
test/busy.test busy-1.3 and busy-1.4: the handler's argument sequence is `0 1 2 3 0 1 2 3`
instead of `0 1 2 3`, because the btree loop's counter is restarted and not latched after the
handler gives up, so the busy handler is invoked again by another path.
