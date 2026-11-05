select coalesce(nullif(0.9999999999 ^ 70000000000000, 0), 0) as underflows;
select (-1.0) ^ 2147483648;
select (-1.0) ^ 2147483649;
