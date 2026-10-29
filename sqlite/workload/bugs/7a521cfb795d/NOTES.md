`repro.sql` runs `SELECT 1 LIKE 'a' ESCAPE NULL;`. The injection removes the `zEsc==0` check in `likeFunc`
(sqlite3_value_text() returns NULL for a NULL value). The clean shell prints an empty row (NULL) and exits 0;
the buggy shell segfaults (exit 139) dereferencing the NULL escape string.
The original test forces the same NULL via malloc failure, which can't be simulated in the shell. A NULL argument reaches the same code path.
