create table idxpart (a int, b int, c text, d bool) partition by range (a);
create table idxpart1 partition of idxpart for values from (0) to (10);
create index on idxpart1 ((a+b)) where d = true;
create index idxparti3 on idxpart ((a+b)) where d = true;
\d idxpart1
