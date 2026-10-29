repro.sql runs a UNION ALL of two SELECTs that each use rank() OVER (...).
The buggy shell rewrites windows on compound selects (the `p->pPrior==0` check was removed),
so the result differs from clean (expected `1|1 2|2 2|1 1|2`).
