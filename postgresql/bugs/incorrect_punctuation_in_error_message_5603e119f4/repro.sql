select sum(x) from (values ('infinity'::interval),('-infinity'::interval)) v(x);
select avg(x) from (values ('infinity'::interval),('-infinity'::interval)) v(x);
