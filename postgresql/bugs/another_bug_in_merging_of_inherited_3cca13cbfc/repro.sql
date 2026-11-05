create table p1 (ff1 int, constraint p2chk check (ff1 > 10));
create table c2 (constraint p2chk check (ff1 > 10) no inherit) inherits (p1);
drop table p1 cascade;
