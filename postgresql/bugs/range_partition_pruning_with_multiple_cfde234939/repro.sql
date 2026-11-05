create table p (a bool, b bool) partition by range (a, b);
create table p_ff partition of p for values from (false,false) to (false,true);
create table p_ft partition of p for values from (false,true) to (true,false);
create table p_tf partition of p for values from (true,false) to (true,true);
create table p_tt partition of p for values from (true,true) to (maxvalue,maxvalue);
explain (costs off) select * from p where a and b;
explain (costs off) select * from p where b and a;
explain (costs off) select * from p where a is true and b is true;
explain (costs off) select * from p where b is true and a is true;
