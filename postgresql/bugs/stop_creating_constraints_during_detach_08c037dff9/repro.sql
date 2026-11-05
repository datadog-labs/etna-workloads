CREATE TABLE hash_parted2 (a int) PARTITION BY HASH(a);
CREATE TABLE part_hp PARTITION OF hash_parted2 FOR VALUES WITH (MODULUS 2, REMAINDER 0);
ALTER TABLE hash_parted2 DETACH PARTITION part_hp CONCURRENTLY;
SELECT count(*) FROM pg_constraint WHERE conrelid = 'part_hp'::regclass;
DROP TABLE hash_parted2;
DO $$ BEGIN INSERT INTO part_hp VALUES (1); RAISE NOTICE 'insert ok';
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'insert failed'; END $$;
