repro.sql: creates t1, then runs CREATE TABLE IF NOT EXISTS t1 with a generated column.
The table already exists, so pParse->pNewTable is NULL in sqlite3AddGenerated().
Clean shell prints "ok" (exit 0). Buggy shell hits the wrong NEVER() assertion in
sqlite3AddGenerated and aborts (exit -6).
