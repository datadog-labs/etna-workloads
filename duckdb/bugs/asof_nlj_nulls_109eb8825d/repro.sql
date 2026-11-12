.mode list
.nullvalue NULL
CREATE TABLE events0 AS
	SELECT '2023-03-21 13:00:00'::TIMESTAMP + INTERVAL (range) HOUR AS begin, range AS value
	FROM range(0, 4);
INSERT INTO events0 VALUES 
	(NULL, -1),
	('infinity', 9)
;
CREATE TABLE probe0 AS 
	SELECT *
	FROM range('2023-03-21 12:00:00'::TIMESTAMP, '2023-03-21 22:00:00'::TIMESTAMP, INTERVAL 1 HOUR) p(begin)
;
INSERT INTO probe0 VALUES 
	(NULL),
	('infinity')
;
CREATE TABLE asof_nulls (
	time TIMESTAMP,
	value FLOAT
);
INSERT INTO asof_nulls (time, value) VALUES ('2025-07-15 00:00:00', 42);
INSERT INTO asof_nulls (time, value) VALUES ('2025-07-15 01:00:00', null);
PRAGMA asof_loop_join_threshold = 0;
SELECT p.begin, e.value
FROM probe0 p ASOF JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF JOIN events0 e
USING (begin)
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF LEFT JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF LEFT JOIN events0 e
USING (begin)
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF RIGHT JOIN events0 e
ON p.begin >= e.begin
ORDER BY ALL;
SELECT p.begin, e.value
FROM probe0 p ASOF RIGHT JOIN events0 e
USING (begin)
ORDER BY ALL;
SELECT p.begin, e.value
FROM probe0 p ASOF LEFT JOIN (SELECT * FROM events0 WHERE log(value + 5) > 10) e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF RIGHT JOIN (SELECT * FROM events0 WHERE log(value + 5) > 10) e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin
FROM probe0 p ASOF SEMI JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin
FROM probe0 p ASOF ANTI JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT time_series.time, asof_nulls.value
FROM (VALUES ('2025-07-15 02:00:00'::TIMESTAMP)) as time_series(time)
ASOF LEFT JOIN asof_nulls ON asof_nulls.time <= time_series.time;
PRAGMA asof_loop_join_threshold = 32;
SELECT p.begin, e.value
FROM probe0 p ASOF JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF JOIN events0 e
USING (begin)
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF LEFT JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF LEFT JOIN events0 e
USING (begin)
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF RIGHT JOIN events0 e
ON p.begin >= e.begin
ORDER BY ALL;
SELECT p.begin, e.value
FROM probe0 p ASOF RIGHT JOIN events0 e
USING (begin)
ORDER BY ALL;
SELECT p.begin, e.value
FROM probe0 p ASOF LEFT JOIN (SELECT * FROM events0 WHERE log(value + 5) > 10) e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin, e.value
FROM probe0 p ASOF RIGHT JOIN (SELECT * FROM events0 WHERE log(value + 5) > 10) e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin
FROM probe0 p ASOF SEMI JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT p.begin
FROM probe0 p ASOF ANTI JOIN events0 e
ON p.begin >= e.begin
ORDER BY p.begin ASC;
SELECT time_series.time, asof_nulls.value
FROM (VALUES ('2025-07-15 02:00:00'::TIMESTAMP)) as time_series(time)
ASOF LEFT JOIN asof_nulls ON asof_nulls.time <= time_series.time;
