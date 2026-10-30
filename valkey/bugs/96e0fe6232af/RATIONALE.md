# Rationale

Fix hunk (scripting.c, evalGenericCommand): removed
`selectDb(c, server.lua_client->db->id)` after the script ran, so a SELECT
inside Lua no longer changes the caller's DB.

9.0.7 change (src/eval.c, evalGenericCommand): after `scriptResetRun(&rctx)`
I re-added `selectDb(c, rctx.c->db->id)`. `rctx.c` is the Lua engine client
(the old `server.lua_client`), so the caller again inherits the DB last
selected by the script. Only the EVAL path is touched, as in the original fix
(FCALL is not changed).

Oracle failure: `EVAL - SELECT inside Lua should not affect the caller`
fails with "Expected 'original value' to equal or match 'this is DB 9'",
because the caller is switched to DB 9 after the script.
