create table rangepart (a int) partition by range (a);
create table rangepart1 partition of rangepart for values from (0) to (10);
create table rangepart2 partition of rangepart for values from (10) to (20);
create table rangepart_def partition of rangepart default;
explain (costs off) select * from rangepart where a is not null and a in(-1,5,15,20);
