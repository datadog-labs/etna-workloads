Reproducer: a WITHOUT ROWID child table whose FK references an INTEGER PRIMARY KEY parent,
with one violating row; then `PRAGMA foreign_key_check`.
Clean shell returns `c30||p30|0` (rowid column NULL). The buggy shell reads a rowid
from a WITHOUT ROWID table, giving a wrong/garbage result (or error/assert).
