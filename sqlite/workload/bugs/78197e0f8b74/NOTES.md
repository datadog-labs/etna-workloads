Reproducer (rowvalue-28.10): a BEFORE DELETE trigger whose SELECT contains a
2-column scalar subquery, then DELETE FROM t0.
Clean shell: "Parse error: sub-select returns 2 columns - expected 1".
Buggy shell: assert in sqlite3WhereEnd (`pOp<pLastOp`) aborts the process.
