SELECT v, CASE WHEN v > 0 THEN v ELSE 1 / 0 END FROM (VALUES (1), (2)) t(v) ORDER BY v;
SELECT v, CASE WHEN v > 0 THEN 10 / v ELSE 10 / 0 END FROM (VALUES (1), (2)) t(v) ORDER BY v;
SELECT case when true then 1 / 1 else 1 / 0 end;
