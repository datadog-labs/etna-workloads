.mode list
.nullvalue NULL
PRAGMA threads=1;
CREATE TABLE b AS SELECT range % 2000 AS k FROM range(1000000);
CREATE TABLE p AS SELECT range % 4000 AS k FROM range(2000000);
SELECT count(*) FROM p WHERE k IN (SELECT k FROM b);
PRAGMA debug_force_external=true;
SELECT count(*) FROM p WHERE k IN (SELECT k FROM b);
CREATE TABLE u1 AS SELECT range AS k, range::VARCHAR AS s FROM range(200000);
CREATE TABLE u2 AS SELECT range AS k, range::VARCHAR AS s FROM range(200000);
CREATE TABLE u3 AS SELECT range % 200000 AS k FROM range(400000);
SELECT count(*) FROM u3 JOIN (
    SELECT x.k FROM (SELECT k, s FROM u1 WHERE s LIKE '%1%' OR s NOT LIKE '%1%') x
    JOIN (SELECT k, s FROM u2 WHERE s LIKE '%2%' OR s NOT LIKE '%2%') y USING (k)
) d USING (k);
