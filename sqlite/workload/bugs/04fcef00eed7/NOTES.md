Inserts `CASE WHEN 1 THEN null END` into an INTEGER PRIMARY KEY column (insert-14.1).
Clean shell prints `1` (NULL becomes an auto rowid). The buggy shell hits an assertion
failure in sqlite3VdbeGetOp (abort, exit status -6), because the constant-folded CASE
emits no opcode for the rowid and the buggy code inspects the last opcode anyway.
