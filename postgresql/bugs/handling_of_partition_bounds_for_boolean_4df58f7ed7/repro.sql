create table boolspart (a bool) partition by list (a);
create table boolspart_t partition of boolspart for values in (true);
create table boolspart_f partition of boolspart for values in (false);
\d+ boolspart
