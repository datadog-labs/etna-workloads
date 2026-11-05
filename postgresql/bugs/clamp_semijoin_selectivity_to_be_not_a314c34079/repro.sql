create table a(x int, y int);
create table b(x int, y int);
insert into a select i, i from generate_series(1,1000) i;
insert into b select i, i from generate_series(1,20) i;
analyze a; analyze b;
explain select * from a where x+1 in (select y*2 from b);
