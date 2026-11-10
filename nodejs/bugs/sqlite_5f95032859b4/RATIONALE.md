# Re-introduced bug: sessions not pinned during SQLite callbacks

**Bug.** Session objects are weak. SQLite runs `PRAGMA table_xinfo` inside its pre-update hook while walking the connection's session list, and that reaches JavaScript (authorizer, `sqlite.db.query` trace subscriber). A GC in such a callback can free a Session SQLite is still using, which causes a use-after-free and a crash.

**Hunks**
1. `src/node_sqlite.h`, `CallbackDepthGuard`: removed the `pinned_sessions_` member and its initialisation from `db->PinSessions()`. This reverses the fix's header hunk, so the guard only bumps the callback depth and holds no strong session references. (`PinSessions()` stays declared and defined but is unused; in the fix it is added by hunks that don't need reverting.)
2. `src/node_sqlite.cc`, `Database::TraceCallback`: moved `CallbackDepthGuard guard(db)` from before the payload allocation back to just before `ch->Publish`. This reverses the fix's trace-callback hunk. Before the fix the guard came after the payload was built.

**Failing test.** `parallel/test-sqlite-session` is `not ok` on both runs. The process dies with exitcode -11 (SIGSEGV) in the "survives GC during ... callback" tests.
