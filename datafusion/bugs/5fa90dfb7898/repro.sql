SELECT a * 1.000::DECIMAL(4,3) > 1.2::decimal(2,1) FROM VALUES (1) AS t(a);
SELECT 1.000::DECIMAL(4,3) * a > 1.2::decimal(2,1) FROM VALUES (1) AS t(a);
SELECT NULL::DECIMAL(4,3) * a > 1.2::decimal(2,1) FROM VALUES (1) AS t(a);
SELECT a * NULL::DECIMAL(4,3) > 1.2::decimal(2,1) FROM VALUES (1) AS t(a);
SELECT a / 1.000::DECIMAL(4,3) > 1.2::decimal(2,1) FROM VALUES (1) AS t(a);
SELECT a / NULL::DECIMAL(4,3) > 1.2::decimal(2,1) FROM VALUES (1) AS t(a);
