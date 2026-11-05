begin;
set default_toast_compression = 'pglz';
create table toasted_data (f1 int[]);
insert into toasted_data
  select array_agg(i) from generate_series(12345678, 12345678 + 1000) i;
declare local_portal cursor for select * from toasted_data;
declare c2 cursor for select 1;
select count(*) from pg_class;
fetch all in local_portal;
rollback;
