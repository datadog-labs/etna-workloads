.mode list
.nullvalue NULL
SET max_execution_time=5000;
CREATE TABLE facts(i BIGINT);
INSERT INTO facts VALUES (0), (0), (1), (2), (NULL);
CREATE TABLE empty_facts(i BIGINT);
CREATE TABLE dimensions(k BIGINT);
INSERT INTO dimensions VALUES (1), (1), (2), (2), (3), (4), (NULL);
CREATE TABLE probes(k BIGINT);
INSERT INTO probes VALUES (-1), (0), (0), (1), (2), (NULL);
CREATE MACRO inlined_chain(input_table) AS TABLE
    WITH a AS NOT MATERIALIZED (
        SELECT * FROM query_table(input_table) f JOIN dimensions d1 ON d1.k = f.i + 1
    ), b AS NOT MATERIALIZED (
        SELECT * FROM a JOIN dimensions d2 ON d2.k = a.i + 2
    ), c AS NOT MATERIALIZED (
        SELECT * FROM b JOIN dimensions d3 ON d3.k = b.i + 3
    )
    SELECT * FROM c;
CREATE MACRO materialized_chain(input_table) AS TABLE
    WITH a AS MATERIALIZED (
        SELECT * FROM query_table(input_table) f JOIN dimensions d1 ON d1.k = f.i + 1
    ), b AS MATERIALIZED (
        SELECT * FROM a JOIN dimensions d2 ON d2.k = a.i + 2
    ), c AS MATERIALIZED (
        SELECT * FROM b JOIN dimensions d3 ON d3.k = b.i + 3
    )
    SELECT * FROM c;
CREATE TABLE guarded_strings(i BIGINT, value VARCHAR);
INSERT INTO guarded_strings VALUES (0, 'bad'), (1, '1'), (2, '2'), (NULL, NULL);
CREATE TABLE guarded_integers(i BIGINT);
INSERT INTO guarded_integers VALUES (1), (2), (9223372036854775807), (NULL);
CREATE MACRO cast_rows(only_valid) AS TABLE
    SELECT a.i, count(*) AS n, sum(a.payload) AS payload
    FROM dimensions d2 JOIN (
        SELECT *, abs(s.i) AS payload
        FROM dimensions d1 JOIN (
            SELECT * FROM guarded_strings WHERE NOT only_valid OR value <> 'bad'
        ) s ON d1.k = s.value::BIGINT + 1
    ) a ON d2.k = a.i + 2
    GROUP BY a.i;
CREATE MACRO overflow_rows(only_valid) AS TABLE
    SELECT a.i, count(*) AS n, sum(a.payload) AS payload
    FROM dimensions d2 JOIN (
        SELECT *, abs(s.i) AS payload
        FROM dimensions d1 JOIN (
            SELECT * FROM guarded_integers WHERE NOT only_valid OR i < 9223372036854775807
        ) s ON d1.k = s.i + 1
    ) a ON d2.k = a.i + 2
    GROUP BY a.i;
EXPLAIN (FORMAT JSON) SELECT i, count(*) FROM inlined_chain('facts') GROUP BY i;
EXPLAIN (FORMAT JSON) SELECT i, count(*) FROM materialized_chain('facts') GROUP BY i;
