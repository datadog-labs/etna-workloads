# Rationale

The fix (#13141) capped `server.errors` at 128 entries so Lua `error_reply` abuse
(a new error code per call) cannot grow the errorstats rax without bound. In 9.0.7
the mechanism was redesigned: there is no `errors_enabled` flag. The cap lives in
`afterErrorReply()` (src/networking.c) and folds new custom errors into
`ERRORSTATS_OVERFLOW` once `raxSize(server.errors) >= ERRORSTATS_LIMIT`.
The lazyfree part of the fix (`freeErrorsRadixTreeAsync`) is still present.

## Change
src/networking.c: removed the `ERR_REPLY_FLAG_CUSTOM && raxSize(server.errors) >= ERRORSTATS_LIMIT`
block that redirects to `ERRORSTATS_OVERFLOW`. This reverses the fix's hunk in
`incrementErrorCount` (the `numele >= ERROR_STATS_NUMBER` limit check), which is the
same defect: no limit on the number of distinct errors, so server.errors grows unbounded.

## Oracle
`errorstats: limit errors will not increase indefinitely` fails:
`Expected 'count=972' to be equal to ''` (no ERRORSTATS_OVERFLOW entry; all 1100
distinct errors are tracked). Other 24 cases pass.
