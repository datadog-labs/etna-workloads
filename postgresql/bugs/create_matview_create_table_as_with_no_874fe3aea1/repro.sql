create materialized view mvtest_error as select 1/0 as x with no data;
select count(*) from pg_class where relname='mvtest_error';
create table ctas_err as select 1/0 as x with no data;
select count(*) from pg_class where relname='ctas_err';
