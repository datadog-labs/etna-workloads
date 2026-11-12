.mode list
.nullvalue NULL
PRAGMA memory_limit='100MB';
SELECT sum(length(s)) FROM (SELECT repeat('x', 1000) s FROM range(300000)) USING SAMPLE 50 PERCENT (reservoir);
