Reproducer (repro.sql): table t0 with one row; queries `WHERE likely(t0.rowid) <= '0'` (also unlikely/likelihood).
Clean shell returns the row `a` three times (likely() has no affinity, so the integer rowid is compared to text '0', and integer < text is true).
Buggy shell returns no rows, because sqlite3ExprSkipCollate also skips likely(), so the rowid's integer affinity is applied to '0'.
