create table at_base_table(id int, stuff text);
insert into at_base_table values (23,'skidoo');
create view at_view_1 as select * from at_base_table bt;
create view at_view_2 as select *, to_json(v1) as j from at_view_1 v1;
create or replace view at_view_1 as select *, 2+2 as more from at_base_table bt;
explain (verbose, costs off) select * from at_view_2;
select * from at_view_2;
