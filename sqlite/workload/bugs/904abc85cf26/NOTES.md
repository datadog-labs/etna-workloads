repro.sql: EXISTS subquery that is a UNION of two selects, in a query with GROUP BY.
The EXISTS-to-JOIN optimization wrongly flattens the compound subquery (missing pSub->pPrior==0 check).
Clean shell prints `1|p1`; buggy shell prints no rows.
