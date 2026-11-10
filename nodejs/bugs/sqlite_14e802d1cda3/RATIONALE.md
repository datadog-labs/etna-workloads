# Rationale

**Bug:** `Database::DeleteSessions()` (called from `close()` and the destructor) deleted the native `sqlite3_session` handles but did not mark the owning `Session` wrappers as closed. After `close()` + `open()`, a wrapper still held a stale handle, so `session.changeset()` / `session.close()` used freed memory instead of throwing "session is not open", crashing the process.

**Change (src/node_sqlite.cc, `Database::DeleteSessions`)**: corresponds to the fix's `DeleteSessions` hunk. The release has been refactored (`Database`, `unique_ptr` session_ with `SessionDeleter`, and the Session tracking and `Session::Delete()` hunks from the fix are already present in that form). I restored the old loop: it deletes the native handle directly via `sqlite3session_delete(session->session_.get())` and then `sessions_.clear()`, instead of calling `Session::Delete()`, which resets the wrapper's pointer. The wrappers keep a dangling handle, which is the original defect.

**Failing test:** `parallel/test-sqlite-session` fails (not ok, exitcode -11, SIGSEGV) in the "session methods - reopened database results in exception" test, in 3 of 3 runs.
