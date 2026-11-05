create table arrlp (a int[]) partition by list (a);
create table arrlp12 partition of arrlp for values in ('{1}', '{2}');
\d+ arrlp12
insert into arrlp values ('{1}'), ('{2}');
select * from arrlp order by 1;
