select arrow_typeof(round('99'::decimal(2,0), -1)), round('99'::decimal(2,0), -1);
select arrow_typeof(round('999.9'::decimal(4,1))), round('999.9'::decimal(4,1)), round('-999.9'::decimal(4,1)), round('99.99'::decimal(4,2));
select arrow_typeof(round(val, dp)), round(val, dp) from (values (cast('999.9' as decimal(4,1)), 0)) as t(val, dp);
select arrow_typeof(round('9999999999999999999999999999999999999.9'::decimal(38,1))), round('9999999999999999999999999999999999999.9'::decimal(38,1));
