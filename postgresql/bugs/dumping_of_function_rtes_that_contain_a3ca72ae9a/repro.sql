create view tt20v as select * from cast(1+2 as int4) as i4, cast(1+2 as int8) as i8;
select pg_get_viewdef('tt20v', true);
