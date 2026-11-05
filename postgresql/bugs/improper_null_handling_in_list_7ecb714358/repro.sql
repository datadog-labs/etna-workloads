create table lp (a int, b char) partition by list (b);
create table lp_a partition of lp for values in ('a');
insert into lp values (1);
select count(*) from lp;
