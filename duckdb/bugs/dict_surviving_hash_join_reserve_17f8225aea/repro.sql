.mode list
.nullvalue NULL
SET disabled_optimizers='join_order,build_side_probe_side';
CREATE TABLE nation AS SELECT i AS nk, 'NATION_' || (i % 5) AS n_name FROM range(25) t(i);
CREATE TABLE customer AS SELECT i * 1000 AS ck, i % 25 AS nk FROM range(2000) t(i);
CREATE TABLE returns AS SELECT i * 2000 AS ck, i % 7 AS dk FROM range(1500) t(i);
CREATE TABLE dates AS SELECT i AS dk, 'day_' || i AS d_name FROM range(7) t(i);
PRAGMA verify_parallelism;
SET threads=1;
SELECT count(*), count(DISTINCT n_name), count(DISTINCT d_name)
FROM dates d RIGHT JOIN (
    SELECT c.ck, n.n_name, r.dk
    FROM customer c JOIN nation n ON c.nk = n.nk
    FULL OUTER JOIN returns r ON c.ck = r.ck
) b ON d.dk = b.dk;
SELECT n_name, count(*)
FROM dates d RIGHT JOIN (
    SELECT c.ck, n.n_name, r.dk
    FROM customer c JOIN nation n ON c.nk = n.nk
    FULL OUTER JOIN returns r ON c.ck = r.ck
) b ON d.dk = b.dk
GROUP BY n_name ORDER BY n_name NULLS LAST;
SELECT d_name, n_name, count(*)
FROM dates d RIGHT JOIN (
    SELECT c.ck, n.n_name, r.dk
    FROM customer c JOIN nation n ON c.nk = n.nk
    FULL OUTER JOIN returns r ON c.ck = r.ck
) b ON d.dk = b.dk
WHERE d_name IN ('day_0', 'day_3') AND (n_name IS NULL OR n_name = 'NATION_1')
GROUP BY ALL ORDER BY ALL NULLS LAST;
SELECT count(*), count(DISTINCT n_name), count(DISTINCT d_name)
FROM dates d RIGHT JOIN (
    SELECT c.ck, n.n_name, r.dk
    FROM customer c JOIN nation n ON c.nk = n.nk
    RIGHT JOIN returns r ON c.ck = r.ck
) b ON d.dk = b.dk;
SELECT count(*), count(DISTINCT n_name), count(DISTINCT d_name)
FROM dates d RIGHT JOIN (
    SELECT c.ck, n.n_name, r.dk
    FROM customer c JOIN nation n ON c.nk = n.nk
    JOIN returns r ON c.ck = r.ck
) b ON d.dk = b.dk;
SET threads=4;
SELECT count(*), count(DISTINCT n_name), count(DISTINCT d_name)
FROM dates d RIGHT JOIN (
    SELECT c.ck, n.n_name, r.dk
    FROM customer c JOIN nation n ON c.nk = n.nk
    FULL OUTER JOIN returns r ON c.ck = r.ck
) b ON d.dk = b.dk;
