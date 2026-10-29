repro.sql: selects `a` from a DISTINCT subquery (`select distinct a, b from t`) over a 6-row table.
Clean shell prints 1,1,1 (subquery not flattened). Buggy shell flattens the DISTINCT subquery
and aborts with assertion `(pSub->selFlags & SF_Distinct)==0' in flattenSubquery (exit -6).
