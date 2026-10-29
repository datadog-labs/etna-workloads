Reproducer (`repro.sql`): creates a UTF-16 database, adds columns with ALTER TABLE ... ADD COLUMN ... DEFAULT, then runs an UPDATE and a SELECT, as in tkt3838-1.1.

The clean shell prints `2|999|9.0e+99|xyzzy`. The buggy shell prints `2|999|9.0e+99|祸空`. The TEXT default is read back with the wrong encoding, because sqlite3ValueFromExpr applies the database encoding before the UTF-8 string is converted.
