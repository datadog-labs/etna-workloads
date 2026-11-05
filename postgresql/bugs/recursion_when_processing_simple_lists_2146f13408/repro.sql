create temp view v as select 1 as a where true and false and (1=1) and 2=2;
select pg_get_viewdef('v'::regclass);
create temp view w as select 1 as a where 1=1 or 2=2 or 3=3 or 4=4;
select pg_get_viewdef('w'::regclass);
