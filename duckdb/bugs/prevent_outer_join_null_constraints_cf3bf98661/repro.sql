.mode list
.nullvalue NULL
CREATE TABLE l2(a BIGINT, ak VARCHAR);
CREATE TABLE r2(b BIGINT, bk VARCHAR);
INSERT INTO l2 VALUES (1, 'x'), (2, 'y'), (3, 'p');
INSERT INTO r2 VALUES (10, 'p'), (11, 'q');
SELECT * FROM (
    SELECT l2.a, l2.ak, r2.b
    FROM l2 LEFT JOIN r2 ON l2.ak = r2.bk
    ORDER BY b DESC NULLS FIRST, a ASC NULLS LAST
    LIMIT 2
) s
WHERE s.b <= 20;
