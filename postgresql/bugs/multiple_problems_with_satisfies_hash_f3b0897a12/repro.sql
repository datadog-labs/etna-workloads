CREATE TABLE h (a int, b text) PARTITION BY HASH (a, b);
SELECT satisfies_hash_partition('h'::regclass, NULL, 0, NULL);
SELECT satisfies_hash_partition('h'::regclass, 4, NULL, NULL);
SELECT satisfies_hash_partition(0, 4, 0, NULL);
