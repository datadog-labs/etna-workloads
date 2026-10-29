repro.sql: the index6-19.2 case. A RIGHT JOIN's left table t2 has a partial index (WHERE c=3) that the buggy build scans, omitting rows. The right-join no-match loop then adds an extra row.
Clean shell: no rows. Buggy shell: one wrong row, `|1|2|`.
