SELECT a.value, b.value FROM generate_series(1,3) AS a LEFT JOIN generate_series(4,5) AS b ON a.value=b.value-3;
