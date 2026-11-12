.mode list
.nullvalue NULL
SET threads = 1;
SELECT count(*), sum(x)
         FROM (
             SELECT unnest(range(200000)) AS u, x
             FROM (
                 SELECT lead(i, 1, 7) OVER () AS x
                 FROM range(1) t(i)
             )
             LIMIT 200001
         );
