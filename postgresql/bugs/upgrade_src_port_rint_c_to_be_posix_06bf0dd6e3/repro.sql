select x, x::float8::int4 as v from (values (-2.5),(-0.5),(0.5),(2.5)) t(x) order by x;
