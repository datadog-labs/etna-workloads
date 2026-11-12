.mode list
.nullvalue NULL
PRAGMA explain_output = OPTIMIZED_ONLY;
CREATE OR REPLACE TABLE floats(x FLOAT);
INSERT INTO floats VALUES (NULL), ('NaN'), ('Infinity'), ('-Infinity'), ('-0.0'), (0), (2), (1e-30);
EXPLAIN SELECT x FROM floats;
EXPLAIN SELECT x / 1 FROM floats;
SET ieee_floating_point_ops=true;
SELECT bool_and((x / 1) IS NOT DISTINCT FROM x), bool_and(signbit(x / 1) = signbit(x)) FILTER (WHERE x = 0) FROM floats;
SELECT isnan(x * 0), isnan(0 / x) FROM floats WHERE isnan(x);
SELECT 1 / x FROM floats WHERE x = 2;
SET ieee_floating_point_ops=false;
SELECT bool_and((x / 1) IS NOT DISTINCT FROM x), bool_and(signbit(x / 1) = signbit(x)) FILTER (WHERE x = 0) FROM floats;
SELECT isnan(x * 0), isnan(0 / x) FROM floats WHERE isnan(x);
SELECT 1 / x FROM floats WHERE x = 2;
CREATE OR REPLACE TABLE floats(x DOUBLE);
INSERT INTO floats VALUES (NULL), ('NaN'), ('Infinity'), ('-Infinity'), ('-0.0'), (0), (2), (1e-30);
EXPLAIN SELECT x FROM floats;
EXPLAIN SELECT x / 1 FROM floats;
