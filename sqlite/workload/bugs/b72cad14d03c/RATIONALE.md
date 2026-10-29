# Rationale

Hunk changed: `src/func.c` charFunc: `sqlite3_malloc64( argc*4+1 )` -> `sqlite3_malloc64( argc*4 )`.

This reverses the fix's only implementation hunk (`argc*4+1` -> `argc*4`). With no arguments,
`char()` requests a 0-byte allocation, which returns NULL, so the function reports
SQLITE_NOMEM. (With arguments it also leaves no room for the trailing NUL written by `*zOut = 0`.)

Oracle failure: `func-31.1` (`SELECT char(), length(char()), typeof(char())` expects `{} 0 text`) fails with a NOMEM error.
