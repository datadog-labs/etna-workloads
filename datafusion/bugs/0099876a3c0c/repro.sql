select avg(d), arrow_typeof(avg(d))
from (
    select arrow_cast(99999.0, 'Decimal32(5, 0)') as d
    from generate_series(1, 21476)
) t;

select avg(d), arrow_typeof(avg(d))
from (
    select arrow_cast('99999999999999', 'Decimal64(14, 0)') as d
    from generate_series(1, 92235)
) t;

select avg(d), arrow_typeof(avg(d))
from (
    select arrow_cast('9999999999999999999999999999999999', 'Decimal128(34, 0)') as d
    from generate_series(1, 21476)
) t;
