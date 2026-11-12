.mode list
.nullvalue NULL
SET threads=1;
SELECT count(*) FROM (SELECT TRY_CAST(l AS MAP(VARCHAR, INTEGER)[]) x FROM (SELECT list({'a': [i::INT]}) l FROM range(3000) t(i)));
SELECT bool_and(x[1]['a'] IS NULL) FROM (SELECT TRY_CAST(l AS MAP(VARCHAR, INTEGER)[]) x FROM (SELECT list({'a': [i::INT]}) l FROM range(2049) t(i)));
