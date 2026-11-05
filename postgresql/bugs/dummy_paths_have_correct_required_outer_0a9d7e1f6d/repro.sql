select * from (select 0 as v0) s0 left join (select 1 as val) s1 on true
  left join lateral (select s1.val as vf where false) s2 on true;
