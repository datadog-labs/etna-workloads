# Rationale

Fix hunk reversed: the `src/os_unix.c` hunk in `unixOpen()` (the `src/main.c`
hunk only adds an error name and is not a behavioural change).

The fix moved the read-only fallback retry *after* the check for a
non-writable directory, so a failed journal create (EACCES) is reported as
SQLITE_READONLY_DIRECTORY. In `tree/src/os_unix.c` I restored the pre-fix order:

1. If `fd<0 && errno!=EISDIR && isReadWrite`, retry read-only first (keeping
   today's `findReusableFd()` reuse path, which is the only difference from
   2018 code).
2. Then, if `fd<0`, set `rc = SQLITE_CANTOPEN_BKPT` via `unixLogError` and only
   afterwards test `isNewJrnl && errno==EACCES && osAccess(...)`.

The read-only retry on a journal overwrites `errno` (ENOENT), so the
READONLY_DIRECTORY test no longer matches and CANTOPEN is returned instead of
SQLITE_READONLY_DIRECTORY / SQLITE_READONLY_RECOVERY.

Oracle: misc7-23.x (write to a db in a read-only directory should give
`SQLITE_READONLY_DIRECTORY`) should fail with a different extended error code.
