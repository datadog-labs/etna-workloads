create temp table tbl_rs(a int, b int);
insert into tbl_rs select i, i from generate_series(1,10)i;
analyze tbl_rs;
set enable_nestloop to off;
set enable_hashagg to off;
select * from tbl_rs t1
where (select a from tbl_rs t2
       where exists (select 1 from
                     (select (b in (select b from tbl_rs t3)) as c from tbl_rs t4 where t4.a = 1) s
                     where c in (select t1.a = 1 from tbl_rs t5 union all select true))
       order by a limit 1) >= 0;
