# Rationale

**Bug:** `StatementSync#close()` and `[Symbol.dispose]()` only refused to finalize the statement currently being stepped. A busy statement (e.g. a paused iterator holding locks) could be finalized from inside an authorizer callback, releasing its locks and changing the outcome of the statement being authorized (e.g. `DROP TABLE` succeeds instead of failing with "database table is locked").

**Changes (src/node_sqlite.cc):**
- Removed `THROW_AND_RETURN_IF_BUSY_IN_AUTHORIZER(env, stmt)` from `StatementSync::Close` – corresponds to the fix's Close hunk.
- Removed it from `StatementSync::Dispose` – corresponds to the fix's Dispose hunk.
- Removed the macro definition itself (now unused) – corresponds to the macro-adding hunk. The header comment hunk in node_sqlite.h is comment-only and left unchanged.

**Failing test:** `parallel/test-sqlite-authz` ("rejects finalizing another active statement"): the close/dispose no longer throws inside the authorizer, so the outcome/assertion mismatches (and DROP TABLE no longer reports a locked table). Fails stably on two runs.
