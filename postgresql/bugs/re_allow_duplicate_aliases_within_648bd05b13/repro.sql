create temp table a(q1 int);
create temp table b(f1 int);
select * from a x join (b x cross join b y(ff)) j on q1 = f1;
