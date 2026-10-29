repro.sql creates t1(id) with an ascending index, then runs
`SELECT * FROM t1 GROUP BY id ORDER BY id DESC`.
Clean shell returns 5,4,3,2,1. Buggy shell returns 1,2,3,4,5, because the
GROUP BY and ORDER BY share the index and the DESC direction is ignored
(revMask is not set).
