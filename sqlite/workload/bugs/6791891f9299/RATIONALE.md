# Rationale

## Changed hunk
`tree/src/sqliteInt.h`, `JFUNCTION` macro: re-added `SQLITE_INNOCUOUS` to the
builtin flags.

This reverses the fix's `sqliteInt.h` hunk that removed `SQLITE_INNOCUOUS`
from `JFUNCTION`. For builtin function definitions that bit is
`SQLITE_FUNC_UNSAFE` (the meaning is inverted internally), so the JSON
functions are again marked unsafe. With `PRAGMA trusted_schema=OFF` they then
fail inside views and triggers with "unsafe use of json_extract()".

The `main.c` hunk in the fix only adds comments (tag-20230109-1), so nothing
changes there. The `sqliteInt.h` doc-comment hunk is also comment-only.
In 3.54.1 `JFUNCTION` has extra parameters, so I edited its flag line
and left the rest unchanged.

## Oracle failure
`trustschema1-4.1` fails with `Error: unsafe use of json_extract()`. That test
selects from a view that calls json_extract() while trusted_schema is OFF.
The other 46 cases pass.
