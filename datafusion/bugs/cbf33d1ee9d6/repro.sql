SET datafusion.sql_parser.parse_float_as_decimal = true;
select log(1e4);
select log(10, 1e4);
select log(2.0, 8e1);
select log(5e3);
select log(value) from (values (1e3), (1e4), (1e5)) as t(value) order by 1;
select log(base, 1e4) from (values (10.0), (2.0), (3.0)) as t(base) order by 1;
