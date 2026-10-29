repro.sql runs the tkt3773 query: a UNION ALL subquery with ORDER BY 2 inside an outer SELECT.
Clean shell returns 2,123,33,4 (exit 0). The buggy shell no longer applies flattener restriction (20),
so the compound subquery is flattened despite its ORDER BY and hits the assertion
`pItem->u.x.iOrderByCol>0` in multiSelectByMerge (abort, exit -6).
