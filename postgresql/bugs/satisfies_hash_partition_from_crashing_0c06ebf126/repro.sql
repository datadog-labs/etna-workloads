CREATE TABLE mchash (a int, b text) PARTITION BY HASH (a, b);
SELECT satisfies_hash_partition('mchash'::regclass, 4, 0, VARIADIC NULL::int[]);
