.mode list
.nullvalue NULL
SET threads=1;
CREATE TABLE big (f BOOLEAN, s VARCHAR);
INSERT INTO big SELECT (i % 3) = 0, ['a', '', 'dup', 'zzz'][(i % 4) + 1] FROM generate_series(1, 30) t(i);
CREATE VIEW v AS SELECT MAX(f) OVER (PARTITION BY s) AS f, s FROM big;
CREATE TABLE p (pb BOOLEAN);
INSERT INTO p VALUES (TRUE), (TRUE), (NULL);
SELECT COUNT(*) FROM p WHERE p.pb IN (SELECT x.f FROM v x JOIN v y ON x.s = y.s CROSS JOIN v z);
SET disabled_optimizers='build_side_probe_side';
SELECT COUNT(*) FROM p WHERE p.pb IN (SELECT x.f FROM v x JOIN v y ON x.s = y.s CROSS JOIN v z);
RESET disabled_optimizers;
INSERT INTO p VALUES (FALSE);
SELECT COUNT(*) FROM p WHERE p.pb NOT IN (SELECT x.f FROM v x JOIN v y ON x.s = y.s);
SELECT COUNT(*) FROM p WHERE EXISTS (SELECT 1 FROM v x WHERE x.f = p.pb);
SELECT COUNT(*) FROM p WHERE p.pb IN (SELECT f FROM v);
