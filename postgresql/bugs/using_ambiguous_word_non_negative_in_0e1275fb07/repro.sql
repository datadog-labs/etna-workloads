create table mchash (a int) partition by hash (a);
SELECT satisfies_hash_partition('mchash'::regclass, 0, 0, NULL);
SELECT satisfies_hash_partition('mchash'::regclass, 1, -1, NULL);
