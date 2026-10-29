repro.sql mirrors joinH-14.0/14.1.2/14.1.3: a NATURAL LEFT JOIN + NATURAL JOIN
on the LHS of a FULL JOIN, where the USING column is INT on t1 and BLOB on t2/t3.
Clean shell returns the row `0|`. Buggy shell returns no rows, because the
coalesce() built for the USING column wrongly gets the affinity of its first arg.
