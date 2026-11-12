.mode list
.nullvalue NULL
CREATE TABLE person(id INTEGER PRIMARY KEY, name VARCHAR, age INTEGER);
INSERT INTO person VALUES (1, 'alice', 10), (2, 'bob', 20), (3, 'carol', 30);
CREATE TABLE knows(src_id INTEGER, dst_id INTEGER);
INSERT INTO knows VALUES (1, 2), (1, 3), (2, 3);
SET explain_output='optimized_only';
EXPLAIN SELECT f.name FROM person p LEFT JOIN (
    SELECT k.src_id, n.name FROM knows k
    JOIN (SELECT *, struct_pack(age := age) AS unused_payload FROM person) n ON n.id = k.dst_id
    JOIN (SELECT DISTINCT id FROM person) s ON s.id = k.src_id
) f ON p.id = f.src_id;
