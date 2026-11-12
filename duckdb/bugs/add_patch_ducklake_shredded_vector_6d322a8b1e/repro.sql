.mode list
.nullvalue NULL
SET threads=1;
PRAGMA debug_verify_vector = 'shredded_vector';
CREATE TABLE variants AS SELECT empty_struct::VARIANT v FROM test_all_types();
SELECT v IS NULL, v IS NOT NULL FROM variants;
