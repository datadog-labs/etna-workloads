create table trg_clone (a int) partition by range (a);
create table trg_clone1 partition of trg_clone for values from (0) to (1000);
alter table trg_clone add constraint uniq unique (a) deferrable;
create table trg_clone2 partition of trg_clone for values from (1000) to (2000);
create table trg_clone3 partition of trg_clone for values from (2000) to (3000) partition by range (a);
create table trg_clone_3_3 partition of trg_clone3 for values from (2000) to (2100);
select tgrelid::regclass, count(*) from pg_trigger
  where tgrelid::regclass in ('trg_clone','trg_clone1','trg_clone2','trg_clone3','trg_clone_3_3')
  group by tgrelid::regclass order by tgrelid::regclass;
