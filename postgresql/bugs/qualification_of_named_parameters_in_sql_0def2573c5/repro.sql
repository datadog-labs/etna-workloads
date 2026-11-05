create temp table compos (f1 int, f2 text);
create function fcompos1(v compos) returns void as $$
insert into compos values (v.*);
$$ language sql;
create function fcompos3(v compos) returns void as $$
select fcompos1(fcompos3.v.*);
$$ language sql;
select fcompos1(row(1,'one'));
select fcompos3(row(3,'three'));
select * from compos;
