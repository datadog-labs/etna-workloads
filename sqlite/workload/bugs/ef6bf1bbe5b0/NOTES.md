Reproducer (repro.sql): fts5 + fts4 tables; in a transaction, write to both and
leave pending fts4 terms, then `DROP TABLE vt1` (fts4 rename/destroy path runs
internal SQL that fires the savepoint method).
Clean: DROP succeeds, exit 0, no output. Buggy: "Error near line 12: SQL logic
error", exit 1 (fts3 savepoint/flush handling without bIgnoreSavepoint).
Mirrors fts5savepoint-3.2.
