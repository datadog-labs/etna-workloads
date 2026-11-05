BEGIN;
CREATE TABLE past_parted (i int) PARTITION BY LIST(i);
CREATE TABLE past_part PARTITION OF past_parted FOR VALUES IN (1);
INSERT INTO past_parted VALUES (1),(1);
ANALYZE past_parted;
DROP TABLE past_part;
ANALYZE past_parted;
SELECT reltuples, relhassubclass FROM pg_class WHERE oid = 'past_parted'::regclass;
COMMIT;
