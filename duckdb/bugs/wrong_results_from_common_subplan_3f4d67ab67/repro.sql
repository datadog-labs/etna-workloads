.mode list
.nullvalue NULL
CREATE VIEW q AS SELECT CAST(v AS VARCHAR) AS id, v AS r FROM range(0, 3) t(v);
CREATE VIEW pairs AS SELECT a.id AS a, b.id AS b FROM q a, q b WHERE a.r < b.r;
CREATE VIEW ids AS
  SELECT s2.id || s3.id AS x
  FROM pairs s1 JOIN q s2 ON s2.id = s1.a JOIN q s3 ON s3.id = s1.b
  WHERE s2.r < s3.r;
CREATE VIEW s AS SELECT x AS id FROM ids GROUP BY x;
CREATE VIEW p AS
  SELECT id, max(nm) AS nm FROM (
    SELECT s1.id AS id, NULL AS nm FROM s s1
    UNION ALL
    SELECT s3.id || s4.id AS id, 'n_' || s3.r || '_' || s4.r AS nm
    FROM pairs s2 JOIN q s3 ON s3.id = s2.a JOIN q s4 ON s4.id = s2.b
    WHERE s3.r < s4.r
  ) GROUP BY id;
SELECT nm FROM p WHERE nm IS NOT NULL ORDER BY 1;
