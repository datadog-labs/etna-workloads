set statement_timeout = '3s';
create table twoconstraints (f1 int unique, f2 box, exclude using gist(f2 with &&));
insert into twoconstraints values(1, '((0,0),(1,1))');
insert into twoconstraints values(2, '((0,0),(1,2))')
  on conflict on constraint twoconstraints_f1_key do nothing;
select * from twoconstraints;
