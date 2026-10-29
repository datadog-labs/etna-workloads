repro.sql: schema/data from test/tkt1443.test (ticket 1433), plus the unique index on Permissions, then the join query with a subquery whose ON clause is `UP.labelId=0 OR UP.labelId=LabelMap.labelId` (OR converted to IN).

Clean shell returns 3 rows (double|.*:runtime, double:runtime|.*:runtime, double:source|.*:runtime). Buggy shell returns no rows, because the IN's right-hand-side table dependencies are computed from pRight instead of pList/pSelect.
