CREATE MACRO f(a := NULL::INTEGER) AS typeof(a);
SELECT f();
