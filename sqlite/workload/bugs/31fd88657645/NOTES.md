repro.sql runs bloom1-5.2: `SELECT ... FROM t2 WHERE 'val' IN (compound SELECT UNION ALL whose
first arm selects from a flattened subquery with ORDER BY)`.
Clean shell returns the row `404`; buggy shell returns no rows (multiSelect no longer
propagates pDest->iSDParm2, so the IN-operator ephemeral table is wrong).
