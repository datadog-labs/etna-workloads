repro.sql runs join8-23010: LEFT JOIN simplified to inner JOIN in a query that also has a RIGHT JOIN.
Clean shell returns `-|-|-|-|y`; the buggy shell clears EP_CanBeNull on NOT NULL column c, so it returns a different result (see check.sh).
