repro.sql: the joinH-15.1 case. A NATURAL LEFT JOIN of a CAST-to-REAL subquery, followed by NATURAL JOIN and a RIGHT JOIN, makes the USING-column coalesce() take its affinity from the wrong place.
Clean shell prints `1.0|9`. Buggy shell prints `|9`, so t0.c0 comes back empty (wrong result).
