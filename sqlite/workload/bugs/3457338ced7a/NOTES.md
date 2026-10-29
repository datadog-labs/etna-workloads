`repro.sql` runs `SELECT printf('%n',0);` (printf2-1.12). The injection makes
`sqlite3StrAppend64` assert `z!=0` even when N==0. The `%n` conversion appends
a NULL pointer with length 0.

- clean: prints an empty row, exit 0.
- buggy: `Assertion 'z!=0' failed`, abort, exit 134.
