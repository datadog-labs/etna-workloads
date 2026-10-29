SELECT * FROM temp.generate_series(1,4);
ATTACH ':memory:' AS aux1;
SELECT * FROM aux1.generate_series(1,4);
