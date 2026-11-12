.mode list
.nullvalue NULL
SELECT list(__mark_join_marker ORDER BY id)
FROM (VALUES (0,NULL::INTEGER[]),(1,[1,2]),(2,[2,1]),(3,[1,NULL::INTEGER])) p(id,k)
JOIN BY(TYPE MARK) (VALUES ([1,2]),([1,NULL::INTEGER])) b(k) ON p.k <> b.k;
