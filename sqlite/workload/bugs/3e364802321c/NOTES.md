Reproducer (`repro.sql`): from SQLite ticket d9f584e936c7a8d0 (where-26.1). The query
`SELECT * FROM t0 WHERE '-1' BETWEEN 0 AND t0.c0` on an INTEGER PRIMARY KEY table
uses OP_SeekGE/LE with the text key '-1'.

Clean shell returns the row `1|a`. The buggy shell returns no rows, because the seek
opcodes leave the key register converted to a number instead of restoring its original
type, which breaks the second comparison. Both shells exit with status 0.
