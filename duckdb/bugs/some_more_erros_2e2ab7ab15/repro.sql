.mode list
.nullvalue NULL
CREATE TABLE test (
    foo INTEGER,
    bar INTEGER GENERATED ALWAYS AS (foo+1) VIRTUAL,
    foobar INTEGER DEFAULT 5
);
INSERT INTO test VALUES (5, DEFAULT);
INSERT INTO test VALUES (10, 3);
SELECT * FROM test;
UPDATE test SET bar = 5;
