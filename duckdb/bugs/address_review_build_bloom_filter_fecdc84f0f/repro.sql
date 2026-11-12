SET threads=1;
CREATE TABLE p AS SELECT range k FROM range(25000000);
SET memory_limit='24MB';
SELECT count(*) FROM p WHERE k IN (SELECT range FROM range(100000000) WHERE range % 50000000 = 0);
