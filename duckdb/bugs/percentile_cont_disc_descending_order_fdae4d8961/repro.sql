.mode list
.nullvalue NULL
SET default_null_order='nulls_first';
SET debug_force_external=true;
CREATE TABLE quantile as
SELECT range r, random() AS q
FROM range(10000)
UNION ALL VALUES (NULL, 0.1), (NULL, 0.5), (NULL, 0.9)
ORDER BY 2;
SELECT quantile_disc(r, 0.5) FROM quantile;
SELECT quantile_disc(r::decimal(10,2), 0.5) FROM quantile;
SELECT quantile_disc(case when r is null then null else [r] end, 0.5) FROM quantile;
SELECT quantile_disc(case when r is null then null else {'i': r} end, 0.5) FROM quantile;
SELECT quantile_disc(r, 1.0) FROM quantile;
SELECT quantile_disc(r, 0.0) FROM quantile;
SELECT quantile_disc(NULL, 0.5) FROM quantile;
SELECT quantile_disc(42, 0.5) FROM quantile;
SELECT quantile_disc(NULL, 0.5);
SELECT quantile_disc(42, 0.5);
SELECT quantile_disc(r, 0.1), quantile_disc(r, 0.5), quantile_disc(r, 0.9) from quantile;
SELECT quantile_disc(d::decimal(4,1), 0.1), quantile_disc(d::decimal(4,1), 0.5), quantile_disc(d::decimal(4,1), 0.9)
FROM range(0,100) tbl(d);
SELECT quantile_disc(d::decimal(8,1), 0.1), quantile_disc(d::decimal(8,1), 0.5), quantile_disc(d::decimal(8,1), 0.9)
FROM range(0,100) tbl(d);
SELECT quantile_disc(d::decimal(12,1), 0.1), quantile_disc(d::decimal(12,1), 0.5), quantile_disc(d::decimal(12,1), 0.9)
FROM range(0,100) tbl(d);
SELECT quantile_disc(d::decimal(18,1), 0.1), quantile_disc(d::decimal(18,1), 0.5), quantile_disc(d::decimal(18,1), 0.9)
FROM range(0,100) tbl(d);
SELECT quantile_disc(d::decimal(24,1), 0.1), quantile_disc(d::decimal(24,1), 0.5), quantile_disc(d::decimal(24,1), 0.9)
FROM range(0,100) tbl(d);
SELECT quantile_disc(col, -0.5)
FROM VALUES (11000), (3100), (2900), (2800), (2600), (2500) AS tab(col);
SELECT 
    percentile_disc(0.8) WITHIN GROUP (ORDER BY x DESC),
    quantile_disc(x, 0.8 ORDER BY x DESC),
FROM 
    (VALUES (2), (1)) _(x);
SELECT
    percentile_disc(0.0) WITHIN GROUP (ORDER BY x DESC),
    quantile_disc(x, [0.0] ORDER BY x DESC),
FROM
    (VALUES (1), (2), (3), (4), (5)) _(x);
