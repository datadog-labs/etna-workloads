repro.sql: WITHOUT ROWID table, `SELECT b FROM t1 WHERE a IN (1,2,3) ORDER BY b ASC NULLS LAST`.
Clean shell prints `one`, `three`, and an empty (NULL) row. The buggy shell aborts with an assertion
failure (resolveP2Values, rc=134) because the IN loop is wrongly coded as a one-row loop when regBignull is set.
