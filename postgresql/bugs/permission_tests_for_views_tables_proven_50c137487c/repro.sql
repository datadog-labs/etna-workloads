create role r_user;
create table t1(q int);
set role r_user;
set constraint_exclusion = on;
select * from
  ((select a.q as x, 1 from t1 a where q > 0)
   union all
   (select b.q as x, 2 from t1 b where q > 0)) ss
where x < 0;
reset role;
reset constraint_exclusion;
drop table t1; drop role r_user;
