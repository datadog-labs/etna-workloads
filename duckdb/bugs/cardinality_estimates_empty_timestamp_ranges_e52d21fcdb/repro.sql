.mode list
.nullvalue NULL
SELECT count(*) FROM range(TIMESTAMP '1992-01-01', TIMESTAMP '1992-12-31', INTERVAL '-1 MONTH') t1, range(3) t2;
