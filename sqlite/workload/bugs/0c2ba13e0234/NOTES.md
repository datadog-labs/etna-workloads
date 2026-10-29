repro.sql: table with two single-column indexes, one row, then
`UPDATE d1 SET a=a+2 WHERE a>0 OR b>0` (OR optimization + one-pass UPDATE).
Clean shell: prints `3|2`, exit 0. Buggy shell: the UPDATE loops forever (never
finishes; killed by timeout, no output), because one-pass is wrongly allowed for
multi-OR scans in UPDATE.
