create table t(a int);
create table tlog(o t, n t, incr bool);
create rule r as on update to t do also
  insert into tlog values(old, new, row(old,old) < row(new,new));
select pg_get_ruledef(oid) from pg_rewrite where rulename='r';
