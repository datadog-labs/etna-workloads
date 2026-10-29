# Rationale

Single hunk, `ext/fts3/fts3.c`, `fts3PutDeltaVarint3()`, reversing the fix's only implementation hunk:

- `iWrite` is `sqlite3_int64` again (fix made it `sqlite3_uint64`).
- Removed the two `assert_fts3_nc()` ordering checks (`iVal>=*piPrev`, `*piPrev>=iVal`) that the fix added.
- Restored the unconditional `assert( *pbFirst==0 || iWrite>=0 )`, which fails on corrupt records whose docids are out of order.

The existing `(u64)` casts (added later to avoid signed-overflow UB) are kept. They are harmless here: the wrapped difference is converted to a negative int64, so the assert fires as it did before the fix.

Oracle: `fts3corrupt4-31.1` (`matchinfo` over the corrupt segdir) aborts with `Assertion '*pbFirst==0 || iWrite>=0' failed` instead of returning "database disk image is malformed".
