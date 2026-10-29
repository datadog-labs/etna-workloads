repro.sql: FTS3 table with columns a, b; query `MATCH 'B:two'` (upper-case column name).
Clean: column name matched case-insensitively -> returns rowid 1 (column b contains 'two').
Buggy: memcmp is case-sensitive, so `B:two` is a plain phrase search -> no match / different rows.
