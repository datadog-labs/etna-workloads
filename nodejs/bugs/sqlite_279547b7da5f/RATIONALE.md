# Re-introduced bug: sqlite calls after close() are not state-checked

Bug: `enableLoadExtension()` and `setAuthorizer()` on a closed database passed a null
connection to SQLite, which terminated the process instead of throwing ERR_INVALID_STATE.

Hunks (src/node_sqlite.cc; in the release the class is `Database`, not `DatabaseSync`):
- `Database::EnableLoadExtension`: removed `THROW_AND_RETURN_ON_BAD_STATE(env, !db->IsOpen(), "database is not open")`
  (fix hunk 1). The fix's isolate refactor hunks are cosmetic and not reverted.
- `Database::SetAuthorizer`: removed the same check (fix hunk 3).
The `EnableDefensive` hunk was only cosmetic.

Failing tests: parallel/test-sqlite-config and parallel/test-sqlite-authz both report "not ok"
(the process crashes / the expected ERR_INVALID_STATE "database is not open" is not thrown).
