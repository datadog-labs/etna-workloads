# Re-introduced bug: sqlite Session holds its Database only weakly

A `Session` kept a `BaseObjectWeakPtr<Database>` to its parent database, so a session
did not keep the database alive. If the JS database handle became unreachable and was
GC'd while the session was still alive, the session pointed at a freed/closed database.

## Hunks (src/node_sqlite.cc, src/node_sqlite.h)
- `DatabaseSync::CreateSession` (now `Database` at ~line 3200): `Session::Create(env, BaseObjectPtr<Database>(db), ...)` -> `BaseObjectWeakPtr<Database>(db)`. Corresponds to fix hunk 1.
- `Session::Session` and `Session::Create` signatures (.cc) and declarations (.h): parameter type `BaseObjectPtr<Database>` -> `BaseObjectWeakPtr<Database>`. Corresponds to the signature hunks of the fix.
- `Session::database_` member (.h): `BaseObjectPtr` -> `BaseObjectWeakPtr`. Corresponds to the header member hunk.
- `Session::MemoryInfo`: removed `tracker->TrackField("database", database_)`, restoring the empty body (the fix added it; a weak ptr need not be tracked).

## Failing test
`parallel/test-sqlite-session` fails (stable over 2 runs):
`Error: session did not keep its database alive` (the database got collected).
