Reproducer (`repro.sql`): uses JSON paths with a quoted key containing an escaped double-quote (`$."A\"Key"`).

- clean: `json_extract` returns 1, and `JSON_SET('{}', '$."\"Key"', 1)` returns `{"\"Key":1}`.
- buggy: the path parser stops at the escaped quote, so `json_extract` returns NULL and `JSON_SET` fails with `bad JSON path` (exit status 1).
