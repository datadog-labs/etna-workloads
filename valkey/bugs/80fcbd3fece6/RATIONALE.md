# Rationale

Fix hunk reversed: `networking.c` `isClientConnIpV6` (`c->conn->type == NULL` → `c->flag.fake`).
The fix introduced `flag.fake` and switched the check to it, because fake clients
(Lua, module temp, AOF) have `conn == NULL`, so `c->conn->type` dereferenced NULL.
In 9.0.7 the flag exists and is set everywhere, and the function additionally has a
`fake || !conn` guard returning 0. I restored the pre-fix body of `isClientConnIpV6`
(old condition `c->conn->type == NULL && server.current_client`, no fallback guard).
The `fake = 1` assignments are left in place since 9.0.7 uses the flag elsewhere.

Oracle failures: CLUSTER SLOTS / SHARDS called from a script (cluster/scripting.tcl)
or loaded from AOF (integration/aof.tcl) reach isClientConnIpV6 with a NULL conn
and crash the server (the start_cluster in scripting.tcl fails/crashes).
