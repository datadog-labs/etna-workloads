create temp table n(id int, f float8);
insert into n values (0,'-inf'),(1,-3),(2,0),(3,100),(4,'inf');
select id, f, first_value(id) over w, last_value(id) over w from n
window w as (order by f range between 'inf' preceding and 'inf' preceding);
select id, f, first_value(id) over w, last_value(id) over w from n
window w as (order by f range between 'inf' following and 'inf' following);
