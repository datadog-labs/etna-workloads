# Rationale

Fix hunk reversed: in `call()` the stats update used `c->lastcmd` and was changed to use the saved `real_cmd`.
In 9.0.7 `real_cmd` is `c->realcmd` (src/server.c, stats block in `call()`, ~line 3931). I changed the
`calls++`, `microseconds +=` and latency-histogram updates there back to `c->lastcmd`. Only that block
changed. Failed-call accounting still uses `real_cmd`. `lastcmd` is not updated by `execCommand` (multi.c)
when it runs queued commands, so it still points at EXEC. This is the same pre-fix defect.

Oracle failure: `command stats for MULTI`. Commands inside MULTI/EXEC are all counted as EXEC
(`calls=4` for exec instead of 1), and set/expire/geoadd are missing.
The other cases still pass because 9.0.7 sets `lastcmd` for scripts and rewritten commands elsewhere.
