# Re-introduced bug: sqlite cannot bind JS booleans

**Bug:** `StatementSync` parameter binding did not support JS `true`/`false`. Binding a boolean fell through to the final `else` and threw `ERR_INVALID_ARG_TYPE` ("Provided value cannot be bound to SQLite parameter N."), instead of binding 1/0.

## Changes (src/node_sqlite.cc, `Statement::BindValue`; the function was renamed/moved from `StatementSync::BindValue` since the fix)
- Hunk 1 (fix's `+ } else if (value->IsBoolean()) { sqlite3_bind_int(...) }`): removed that branch, so booleans hit the unsupported-type error again.
- Hunk 2 (fix's comment edit): restored the old comment wording ("such as booleans and Dates could be supported..."), dropping the sentence about booleans binding to 1/0. The later-added "undefined binds to NULL" sentence is kept.

## Failing test
`parallel/test-sqlite-data-types` fails (stable over 2 runs): `TypeError: Provided value cannot be bound to SQLite parameter 2.` (from the `stmt.run(5, true, false, true, null)` case).
