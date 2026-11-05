create temp table graph0(f int, t int, label text);
insert into graph0 values (1,2,'a'),(2,3,'b'),(1,4,'c'),(4,5,'d');
explain (verbose, costs off)
with recursive search_graph(f, t, label) as (
	select * from graph0 g
	union all
	select g.* from graph0 g, search_graph sg where g.f = sg.t
) search breadth first by f, t set seq
select * from search_graph order by seq;
