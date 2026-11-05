create table inh_parent (a int not null);
create table inh_child (a int);
alter table inh_child inherit inh_parent;
create table p2(a int primary key) partition by list (a);
create table p2c(a int);
alter table p2 attach partition p2c for values in (1);
create table p3(a int not null) partition by list (a);
create table p3c(a int primary key);
alter table p3 attach partition p3c for values in (1);
