repro.sql builds the seekscan1 table (PK(a,b,c), ~2000 rows plus ('abc',234,6) and ('abc',345,7)), runs ANALYZE, then queries
`WHERE b IN (234,345) AND c>=6 AND a='abc'`.
Clean shell returns both rows (abc|234|6 and abc|345|7). The buggy shell returns only abc|234|6, because the seek-scan
optimization skips the valid row when an inequality constraint follows the IN term.
