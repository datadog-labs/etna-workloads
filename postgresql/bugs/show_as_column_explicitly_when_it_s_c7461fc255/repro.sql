create view v1 as select 1 as a, 2*1 from (values(1)) t(x);
create view v as select * from (select 1 as a, 2+x from (values(1)) t(x)) s union all select 1,2;
select pg_get_viewdef('v'::regclass);
