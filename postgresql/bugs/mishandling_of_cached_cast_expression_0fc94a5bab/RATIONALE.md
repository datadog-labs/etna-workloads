# Rationale

**File/function:** src/pl/plpgsql/src/pl_exec.c, `get_cast_hashentry()`

**Traces to:** the fix.patch hunk at the end of `get_cast_hashentry`. That hunk is the "prepare the expression for execution if not already done in the current transaction" block. It re-creates `cast_exprstate` when `cast_lxid != curlxid || cast_in_use`.

**Change:** the condition is now `cast_entry->cast_exprstate == NULL || cast_entry->cast_in_use`, so the transaction-id (LXID) check is gone.

**Why this brings the bug back:** the cached ExprState is built in `simple_eval_estate->es_query_cxt`, which only lives for the transaction. Without the LXID check, the state tree is built once and then reused for the rest of the session. In later transactions it points into freed transaction memory. This is the original "cached cast-expression state trees survive beyond their memory context" bug. The current code's other parts (the expression/state hash split) are left as they were.

**Failing oracle case:** src/test/regress||plpgsql
