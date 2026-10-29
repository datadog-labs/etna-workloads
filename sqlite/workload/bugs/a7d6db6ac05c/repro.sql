SELECT likely(CAST(1 AS INT))=='1';
SELECT unlikely(CAST(1 AS INT))=='1';
SELECT likelihood(CAST(1 AS INT),0.5)=='1';
