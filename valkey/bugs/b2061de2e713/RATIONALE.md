# Rationale

Only the MISCONF part of the fix is reintroduced: a broken protocol when the server can't persist to RDB.

## Hunk changed
`src/server.c`, `processCommand`: removed the `sdssubstr(err, 0, sdslen(err)-2)` call (and its comment). It reverses this fix hunk:

    +            /* remove the newline since rejectCommandSds adds it. */
    +            sdssubstr(err, 0, sdslen(err)-2);

`writeCommandsGetDiskErrorMessage()` returns `shared.bgsaveerr`, which already ends in `\r\n`. Without the strip, `rejectCommandSds` appends a second `\r\n`. This is the pre-fix "excessive newline" on the RDB MISCONF error. The other hunks of the fix (the `pre_command_oom_state` rename, `isInsideYieldingLongCommand`, the new RM_Call checks) are not reversed.

## Oracle failure
`tests/integration/rdb.tcl` "failed bgsave prevents writes" fails. After the failed bgsave, `r set x y` gets an extra `\r\n`, and the client reports `Bad protocol, '' as reply type byte` instead of `MISCONF *`.
