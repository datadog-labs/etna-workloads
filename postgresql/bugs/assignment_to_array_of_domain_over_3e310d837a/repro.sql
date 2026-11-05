create type comptype as (cf1 int, cf2 int);
create domain dcomptype as comptype check ((value).cf1 > 0);
create table dcomptable (f1 dcomptype[]);
insert into dcomptable values (null);
update dcomptable set f1[1].cf2 = 5;
table dcomptable;
update dcomptable set f1[1].cf1 = 1;
table dcomptable;
