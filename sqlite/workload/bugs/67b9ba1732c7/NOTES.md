repro.sql: table with a REAL generated column `c0 REAL AS(1) UNIQUE` (so it can be read from the index), then selects it.
Clean shell returns `1.0` for c0 (REAL affinity applied) and the BETWEEN result 0; the buggy shell skips OP_RealAffinity when the value comes from the index, so c0 shows as integer `1` and/or the BETWEEN result differs.
