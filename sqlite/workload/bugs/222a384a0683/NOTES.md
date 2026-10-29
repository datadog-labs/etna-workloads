Reproducer (`repro.sql`): upsert1-600 from the fix. Inserts '1' (text) into an INT PRIMARY KEY column of a WITHOUT ROWID table with a UNIQUE index, using INSERT OR IGNORE ... ON CONFLICT(a) DO NOTHING, then runs `PRAGMA integrity_check`.

Clean shell prints `ok`. Buggy shell applies column affinity after the uniqueness check, so the row is stored with TEXT in t1.a and the index is inconsistent. It prints "TEXT value in t1.a" and "row 1 missing from index sqlite_autoindex_t1_1".
