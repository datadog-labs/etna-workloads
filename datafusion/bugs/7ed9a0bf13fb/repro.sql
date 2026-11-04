SELECT power(2::decimal(38, 0), -5), arrow_typeof(power(2::decimal(38, 0), -5));
SELECT power(2.5::decimal(20, 4), 10), arrow_typeof(power(2.5::decimal(20, 4), 10));
SELECT power(2.5::decimal(2, 1), 4::bigint), arrow_typeof(power(2.5::decimal(2, 1), 4::bigint));
