.bail off
ATTACH ':memory:' AS b;
CREATE TABLE b.t(i INT);
INSERT INTO b.t VALUES (1);
SET debug_checkpoint_abort='in_memory_checkpoint';
BEGIN;
SELECT count(*) FROM b.t;
CHECKPOINT b;
.open :memory:
SELECT 42;
