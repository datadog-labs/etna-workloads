.mode list
.nullvalue NULL
SET debug_disable_optimizer=false;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b AND c>d;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a<b AND c>d;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a<b AND c>d AND a<>b;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b AND a+b>0;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a+b=3;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b AND NULL::BOOLEAN;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b AND c IS NOT DISTINCT FROM d;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a<2 AND a>2;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a IS DISTINCT FROM b AND c IS DISTINCT FROM d;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b-1 AND a=a+1;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b-1 AND 1=a+b;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON TRUE;
SELECT 1 = ANY(SELECT 1);
SELECT NULL::INTERVAL IN (SELECT INTERVAL 1 DAY);
SELECT a,__mark_join_marker FROM (VALUES (1,NULL::INT),(2,3)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,NULL::INT)) b(b,d) ON a IS NOT DISTINCT FROM b AND c IS NOT DISTINCT FROM d ORDER BY a;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,2)) b(b,d) ON a=b AND c=d;
SELECT __mark_join_marker FROM (VALUES (1)) p(a) JOIN BY(TYPE MARK) (VALUES (1)) b(b) ON a=(SELECT b);
WITH probes(id,g,h) AS (VALUES (0,1,NULL::INT),(1,2,3),(2,NULL,4),(3,1,NULL::INT)), candidates(g,h) AS (VALUES (1,NULL::INT),(NULL,4),(NULL,4)), actual AS (SELECT id,__mark_join_marker m FROM probes p JOIN BY(TYPE MARK) candidates c ON p.g IS NOT DISTINCT FROM c.g AND p.h IS NOT DISTINCT FROM c.h), expected AS (SELECT id,EXISTS(SELECT 1 FROM candidates c WHERE p.g IS NOT DISTINCT FROM c.g AND p.h IS NOT DISTINCT FROM c.h) m FROM probes p) SELECT count(*) FROM actual a JOIN expected e USING(id) WHERE a.m IS DISTINCT FROM e.m;
SET debug_disable_optimizer=true;
SELECT __mark_join_marker FROM (VALUES (1,2)) p(a,c) JOIN BY(TYPE MARK) (VALUES (1,3)) b(b,d) ON a=b AND c>d;
