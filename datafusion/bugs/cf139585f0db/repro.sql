SELECT * FROM (VALUES (MAP {'k1': 1}), (MAP {'k1': NULL})) ORDER BY 1;
SELECT * FROM (VALUES (MAP {'k1': NULL}), (MAP {'k1': 1})) ORDER BY 1;
SELECT arrow_typeof(column1) FROM (VALUES (MAP {'k1': NULL}), (MAP {'k1': 1.5}));
