create table at_tab1 (a int, b text) partition by list(a);
create table at_tab2 (x int, y at_tab1);
alter table at_tab1 alter column b type varchar;
drop table at_tab1, at_tab2;
