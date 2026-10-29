Reproducer (repro.sql): inserts 3000 rows into an fts5 table with many distinct tokens
(w1, w1x, ...), then reads fts5vocab.

Clean shell: prints `6001|9000|9000`, exit 0.
Buggy shell: assertion failure `fts5HashEntryMerge: Assertion cmp!=0 failed` (exit 134),
because the injected key comparison in sqlite3Fts5HashWrite no longer checks the
key length, so distinct tokens are wrongly treated as the same hash entry.
