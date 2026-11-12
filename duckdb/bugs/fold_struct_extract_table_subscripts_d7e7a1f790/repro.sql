.mode list
.nullvalue NULL
CREATE TABLE t (grd_quart INTEGER, typl INTEGER, ipondl INTEGER, catl VARCHAR);
INSERT INTO t VALUES (1, 2, 100, '1'), (1, 2, 200, '1');
FROM t AS s
SELECT grd_quart, s['typl'], sum(ipondl) AS eft
WHERE catl = '1'
GROUP BY ALL
ORDER BY ALL;
FROM t AS s
SELECT grd_quart, typl, sum(ipondl) AS eft
WHERE catl = '1'
GROUP BY ALL
ORDER BY ALL;
SET VARIABLE col = 'typl';
FROM t AS s
SELECT grd_quart, s[getvariable('col')], sum(ipondl) AS eft
WHERE catl = '1'
GROUP BY ALL
ORDER BY ALL;
EXPLAIN SELECT grd_quart, s['typl'], sum(ipondl) FROM t AS s WHERE catl = '1' GROUP BY ALL;
