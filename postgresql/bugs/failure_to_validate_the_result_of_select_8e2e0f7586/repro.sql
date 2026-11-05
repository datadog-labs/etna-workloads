select '(0,0)'::point in ('(0,0,0,0)'::box, point(0,0));
SELECT array_agg(x) || array_agg(x) FROM (VALUES (ROW(1,2)), (ROW(3,4))) v(x);
