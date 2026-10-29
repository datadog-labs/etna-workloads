`repro.sql` runs `SELECT y.* FROM t1 x JOIN t2 y USING(a,b)` (and a NATURAL JOIN variant), as in tkt3522.
With the bug, `tbl.*` wrongly drops USING/NATURAL-merged columns of the right table.
Clean shell: returns `1|2` for each query. Buggy shell: assertion failure `p->pEList!=0` in sqlite3Select (exit -6).
