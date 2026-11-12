.mode list
.nullvalue NULL
SET threads=1;
SELECT 1 FROM (SELECT 1 a) JOIN (SELECT 0 b) ON a > b AND a + b > 0;
