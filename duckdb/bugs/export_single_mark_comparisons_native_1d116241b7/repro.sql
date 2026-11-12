.mode list
.nullvalue NULL
SET debug_verify_statement='explain_sql_strict';
SELECT a,b,__mark_join_marker FROM (VALUES (1,1),(2,2),(NULL,2)) l(a,b)
JOIN BY (TYPE MARK) (VALUES (1,1),(1,1),(2,NULL)) r(c,d) ON a=c AND b=d
ORDER BY a NULLS LAST;
SELECT a,b,__mark_join_marker FROM (VALUES (1,1),(2,2),(NULL,2)) l(a,b)
JOIN BY (TYPE MARK) (VALUES (1,1),(1,1),(2,NULL)) r(c,d)
ON a IS NOT DISTINCT FROM c AND b IS NOT DISTINCT FROM d ORDER BY a NULLS LAST;
SELECT a,__mark_join_marker FROM (VALUES (1),(3),(NULL)) l(a)
JOIN BY (TYPE MARK) (VALUES (2)) r(b) ON a<b ORDER BY a NULLS LAST;
SELECT a,__mark_join_marker FROM (VALUES (1),(NULL)) l(a)
JOIN BY (TYPE MARK) (SELECT 1 b WHERE false) r ON a=b ORDER BY a NULLS LAST;
SET debug_verify_serializer=true;
CREATE TABLE mark_boundary_l(i INTEGER,t TUPLE(INTEGER,INTEGER));
CREATE TABLE mark_boundary_r(i INTEGER,t TUPLE(INTEGER,INTEGER));
INSERT INTO mark_boundary_l VALUES (NULL,(1,NULL)),(1,(2,3));
INSERT INTO mark_boundary_r VALUES (NULL,(1,2)),(2,(3,4));
SELECT l.i,__mark_join_marker FROM mark_boundary_l l JOIN BY (TYPE MARK) mark_boundary_r r ON l.i IS DISTINCT FROM r.i ORDER BY l.i NULLS FIRST;
