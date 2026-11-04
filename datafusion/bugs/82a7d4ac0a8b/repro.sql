SELECT pow(0, -0.5);
SELECT power(0.0::float8, -1.0::float8);
SELECT power(base, exp) FROM (VALUES (0.0::double, -1.0::double)) AS t(base, exp);
