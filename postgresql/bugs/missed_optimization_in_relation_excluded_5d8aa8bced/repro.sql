create temp table parent(k int primary key, pd int);
create temp table child(k int primary key, cd int);
explain (costs off)
select p.* from parent p left join child c on (p.k = c.k)
where p.k = 1 and p.k = 2;
