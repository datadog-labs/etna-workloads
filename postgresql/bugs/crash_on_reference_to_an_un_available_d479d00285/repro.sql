create table utrtest (a int, b text) partition by list (a);
create table utr1 (a int check (a in (1)), q text, b text);
create table utr2 (a int check (a in (2)), b text);
alter table utr1 drop column q;
alter table utrtest attach partition utr1 for values in (1);
alter table utrtest attach partition utr2 for values in (2);
insert into utrtest values (2, 'bar')
  returning *, tableoid::regclass, xmin is not null as xmin_ok;
