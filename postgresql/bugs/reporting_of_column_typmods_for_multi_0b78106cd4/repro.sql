create view vv as select * from (values ('abc'::varchar(3)), ('0123456789'::varchar(10))) v(a);
\d vv
select a::varchar(3) from vv;
drop view vv;
