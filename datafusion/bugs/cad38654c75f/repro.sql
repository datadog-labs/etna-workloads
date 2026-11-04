SELECT approx_percentile_cont_with_weight(w, 0.5) WITHIN GROUP (ORDER BY v) AS p
FROM (VALUES (1.0, 1.0), (2.0, 1.0), (3.0, 10.0)) AS t(v, w);
SELECT approx_percentile_cont_with_weight(0, 0) WITHIN GROUP (ORDER BY 'NaN'::DOUBLE) FROM (VALUES (1)) t(x);
