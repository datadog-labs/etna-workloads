repro.sql: creates an fts5 table with detail=none and runs a query containing two error classes (`a:a &`: column filter + syntax error).
Clean: `fts5: syntax error near "&"`. Buggy: reports `column queries are not supported (detail=none)` (the error overwritten, not routed via sqlite3Fts5ParseError) and the shell prints "Memory leaked: 32 bytes".
