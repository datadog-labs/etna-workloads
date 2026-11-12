CREATE TABLE l(id INT); CREATE TABLE r(id INT);
INSERT INTO l VALUES (1),(2); INSERT INTO r VALUES (1);
SELECT l.id, count(r.*) OVER () FROM l LEFT JOIN r ON l.id = r.id ORDER BY 1;
SELECT count(r.*) FROM l LEFT JOIN r ON l.id = r.id;
