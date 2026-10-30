# Rationale

In 9.0.7 `streamCreateConsumer()` (with `SCC_NO_NOTIFY`/`SCC_NO_DIRTIFY`) already exists, so the fix's refactor cannot be reversed literally. The pre-fix bug was that consumers created as a side effect of XREADGROUP, XCLAIM and XAUTOCLAIM produced no `xgroup-createconsumer` keyspace event and no `server.dirty++`. I re-created that by passing `SCC_NO_NOTIFY | SCC_NO_DIRTIFY` at those three call sites in `src/t_stream.c`.

Hunks reversed:
- `xreadCommand`: fix hunk creating the consumer with `SCC_DEFAULT`. The old `streamLookupConsumer(..., &created)` never notified or dirtied.
- `xclaimCommand`: fix hunk with `streamCreateConsumer(..., SCC_DEFAULT)`. Pre-fix, implicit creation was silent.
- `xautoclaimCommand`: same as XCLAIM.

The `blocked.c` hunk has no counterpart in 9.0.7 (blocked XREADGROUP now goes through `xreadCommand`), so it needed no change. XGROUP DELCONSUMER already guards on a non-existent consumer, and I left it alone. XGROUP CREATECONSUMER keeps `SCC_DEFAULT` and still notifies.

## Oracle failures
`tests/unit/pubsub.tcl` "Keyspace notifications: stream events test" fails. The XREADGROUP (Alice) and XCLAIM (Mike) consumer creations emit no `xgroup-createconsumer`, so the test reads `xgroup-delconsumer` where it expects `xgroup-createconsumer`. Four other pubsub cases also fail: "RESP3 publish to self keeps push frame contiguous under copy avoidance", "publish to self inside multi", "publish to self inside script" and "unsubscribe inside multi, and publish to self". I read them as knock-on failures from the desynced notification stream, not separate bugs.
