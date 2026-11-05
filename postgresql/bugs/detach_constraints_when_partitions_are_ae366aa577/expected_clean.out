create table p (a int primary key) partition by list (a);
create table p1 partition of p for values in (1);
alter table p detach partition p1;
alter table p1 drop constraint p1_pkey;
create table q (a int unique) partition by list (a);
create table q1 partition of q for values in (1);
alter table q detach partition q1;
alter table q1 drop constraint q1_a_key;
