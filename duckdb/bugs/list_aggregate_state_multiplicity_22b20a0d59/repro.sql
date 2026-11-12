.mode list
.nullvalue NULL
CREATE TABLE issue_24806(i INTEGER, g INTEGER, d INTEGER, txt INTEGER, chr INTEGER);
INSERT INTO issue_24806 VALUES
    (1, 1, 1, 1, 0),
    (1, 1, 1, 1, 0),
    (42, 1, 2, 3, 9),
    (42, 1, 1, 2, 2),
    (NULL, -7, 1, 0, 0),
    (42, NULL, 3, NULL, 3);
SELECT t1.g, median(t3.i)
FROM issue_24806 t1
INNER JOIN issue_24806 t2 ON t1.d = t2.d
INNER JOIN issue_24806 t3 ON t2.txt = t3.chr
GROUP BY t1.g;
