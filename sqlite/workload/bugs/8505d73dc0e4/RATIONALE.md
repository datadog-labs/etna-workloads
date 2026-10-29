# Rationale

## Change: tree/src/json.c, jsonArrayStep()
Reverses the single implementation hunk of fix.patch (ext/misc/json1.c). The JSON code now lives in src/json.c.
The fix moved `pStr->pCtx = ctx;` out of the `else if( pStr->nUsed>1 )` branch so it runs on every step.
I put it back inside that branch, so pCtx is refreshed only when a ',' is appended.
For json_group_array() as a window function, the aggregate context outlives a single step call.
A step that doesn't take that branch leaves a stale `sqlite3_context` pointer in the JsonString.
Errors raised while appending a value, such as "JSON cannot hold BLOB values", then use the stale pCtx.

## Oracle failure
corruptL-18.1 (json_group_array(c) OVER win4 with a RANGE frame) aborts with
`Assertion 'sqlite3_mutex_held(pCtx->pOut->db->mutex)' failed` in sqlite3_result_error.
It should return `1 {JSON cannot hold BLOB values}`.
