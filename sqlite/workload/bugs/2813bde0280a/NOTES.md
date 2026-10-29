repro.sql builds t5(a,b,c) with UNIQUE index on (a,b) holding duplicate-looking rows
(NULLs are distinct in a unique index), then runs `WHERE a IS NULL AND b='x'`.
Clean shell returns both rows (`|x|two` and `|x|ii`); the buggy shell treats the index
as unique (ignoring uniqNotNull) so it stops after one row.
