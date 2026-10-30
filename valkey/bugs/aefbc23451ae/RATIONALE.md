# Rationale

Fix: `updateClientOutputBufferLimit` (shared by CONFIG SET and config-file parsing) validates hard/soft/soft_seconds. In 9.0.7 the function exists in `src/config.c` and rejects bad values.

Change (one hunk, `src/config.c`, `updateClientOutputBufferLimit`): the check is reduced to `soft_seconds < 0`. This drops the `hard_err || soft_err` test and the `*soft_seconds_eptr != '\0'` trailing-garbage test. This reverses the fix's added validation (`memtoull(..., &hard_err)` and the `strtoll` end-pointer check). Before the fix, the config-file path called `memtoull(argv[2], NULL)` and `atoi`, with only a negative-seconds check, so unparseable sizes silently became 0 and `60s` was accepted.

Oracle failure: `CONFIG SET client-output-buffer-limit` in tests/unit/obuf-limits.tcl. `config set client-output-buffer-limit "normal 10mbs 10mb 60"` returns OK instead of an `*Error*hard*` error. The other 12 cases pass.
