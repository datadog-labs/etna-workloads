# Rationale

**Bug:** An authorizer callback registered with `setAuthorizer()` can freely call connection-mutating APIs on the same `DatabaseSync` (prepare, exec, statement run/get/all/iterate, tag store methods, session changeset, etc.), which SQLite forbids (unsafe, can crash). The fix tracks authorizer depth on the connection.

**Change (src/node_sqlite.cc, 1 hunk):** removed `AuthorizerDepthGuard authorizer_guard(db);` from `Database::AuthorizerCallback`. This corresponds to the fix hunk adding that guard in `AuthorizerCallback`. Without it `authorizer_depth_` never rises above 0, so `IsInAuthorizerCallback()` is always false and every `THROW_AND_RETURN_IF_IN_AUTHORIZER` check (and the limits setter / busy-statement check) is inert, restoring the old behaviour. The stepping-statement tracking (second hazard) is left intact, so test-sqlite-udf-close still passes.

**Failing test:** `parallel/test-sqlite-authz` (not ok): the "authorizer callback reentrancy" tests get 'did not throw' instead of `ERR_INVALID_STATE: database cannot be accessed from an authorizer callback`.
