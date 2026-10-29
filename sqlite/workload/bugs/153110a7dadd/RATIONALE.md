# Rationale

## src/build.c, sqlite3AddPrimaryKey()
Removed the `sqlite3StringToId(pCExpr);` call from the column loop. This reverses
the fix's hunk that added that call (the fix also moved the helper above
sqlite3AddPrimaryKey; in 3.54.1 it is already defined earlier, and still used by
sqlite3CreateIndex, so only the call is removed).

Without it, `PRIMARY KEY('a')` leaves a TK_STRING that is not matched as a column
name, so the column is not recognised as an INTEGER PRIMARY KEY and an
autoindex is created instead.

## Oracle failure
test/index3.test index3-2.5: expected `t2a t2b t2c t2d`, got
`sqlite_autoindex_t2d_1 t2a t2b t2c t2d` (t2d, with `PRIMARY KEY('a')`, is no longer a rowid alias).
