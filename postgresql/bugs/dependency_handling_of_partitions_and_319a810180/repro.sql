begin;
create temp table t_oncommit_p (a int) on commit drop;
create temp table t_oncommit_c () inherits(t_oncommit_p) on commit delete rows;
insert into t_oncommit_c values (1);
commit;
select relname from pg_class where relname like 't_oncommit_%';
