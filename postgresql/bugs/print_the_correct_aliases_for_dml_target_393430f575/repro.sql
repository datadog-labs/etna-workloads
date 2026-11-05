create table src(f1 int, f2 int);
create table lg(f1 int, f2 int);
create table i4(f1 int);
create rule r7 as on delete to src do instead
  with wins as (insert into i4 as trgt values (0) returning f1),
       wupd as (update i4 trgt set f1 = f1+1 returning f1),
       wdel as (delete from i4 trgt where f1 = 0 returning f1)
  insert into lg AS trgt select old.f1, 1 from wins, wupd, wdel
  returning trgt.f1, trgt.f2;
select pg_get_ruledef(oid) from pg_rewrite where rulename='r7';
