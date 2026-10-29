Reproducer (repro.sql): `SELECT t1.* FROM t1 RIGHT JOIN t2 USING(a,b)` (from join-36.2).
Clean shell prints `NULL|NULL|NULL` (t1.* is t1's own a,b,c, all NULL for the unmatched right row).
Buggy shell prints `40|50|NULL`: the check on an explicit table name (`zTName`) was removed, so
t1.* takes the USING-merged a,b from t2 instead of t1's columns.
