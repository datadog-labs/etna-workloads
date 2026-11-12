.mode list
.nullvalue NULL
SELECT INTERVAL '1952257854 days 3 months' * 1.1;
SELECT 1.1 * INTERVAL '1952257854 days 3 months';
SELECT INTERVAL '-1952257855 days -3 months' * 1.1;
SELECT INTERVAL '1952257854 days 3 months' / 0.9090909090909091;
SELECT datepart('month', i), datepart('day', i) FROM (SELECT INTERVAL '1952257845 days 3 months' * 1.1 AS i) t;
SELECT datepart('month', i), datepart('day', i) FROM (SELECT INTERVAL '-1952257854 days -3 months' * 1.1 AS i) t;
SELECT INTERVAL '2 days 3 months' * 1.1;
