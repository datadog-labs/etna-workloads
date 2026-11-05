create table listp (a int) partition by list (a);
create table listp_1 partition of listp for values in (1);
create table listp_2 partition of listp for values in (2);
explain (analyze, costs off, summary off, timing off, buffers off)
select * from listp where a = (select null::int);
