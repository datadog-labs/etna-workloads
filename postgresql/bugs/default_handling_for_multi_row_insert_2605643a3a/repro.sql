create table rules_src(f1 int, f2 int default 0);
create table rules_log(f1 int, f2 int, tag text, id serial);
insert into rules_src values(1,2), (11,12);
create rule r1 as on update to rules_src do also
  insert into rules_log values(old.*, 'old', default), (new.*, 'new', default);
update rules_src set f2 = f2 + 1;
select * from rules_log;
