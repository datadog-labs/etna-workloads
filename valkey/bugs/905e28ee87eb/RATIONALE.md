# Rationale

Bug: closed client connections were not freed while loading (events processed
through processEventsWhileBlocked), because the async-free queue was only drained
by the main-loop beforeSleep.

## Changes
1. `src/server.c`, `beforeSleep()`, ProcessingEventsWhileBlocked branch: removed
   `processed += freeClientsInAsyncFreeQueue();`.
   Reverses the fix hunk that makes beforeSleep run during loading and call
   `freeClientsInAsyncFreeQueue` ("the most important" action). Pre-fix, beforeSleep was
   never called from processEventsWhileBlocked, so the queue was never drained there.
   In 9.0.7 the hook is already registered and called, so dropping the call from the
   reduced loading branch restores the same behaviour.
2. `src/networking.c`, `beforeNextClient()`: removed the `if (c->flag.close_asap) freeClient(c)`
   block. This is a second path that also freed a client flagged by `freeClientAsync` right after
   its read handler ran, so the loading case was covered twice (without it, change 1 alone
   changes nothing). In the main loop, such clients are still freed by beforeSleep, so only the
   loading case regresses, as before the fix.

## Oracle
`client freed during loading` (tests/integration/rdb.tcl) fails with "clients didn't disconnect":
closed clients stay in `connected_clients` during loading. The other 20 cases pass.
