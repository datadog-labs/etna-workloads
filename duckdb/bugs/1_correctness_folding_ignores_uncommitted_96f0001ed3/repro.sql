.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
CREATE TYPE mood AS ENUM('sad', 'ok', 'happy');
CREATE TABLE covered AS SELECT ['sad', 'ok', 'happy'][1 + (range % 3)]::mood AS m FROM range(6144);
CREATE TABLE nullables(m mood);
INSERT INTO nullables SELECT ['sad', 'ok', 'happy'][1 + (range % 3)]::mood FROM range(6144);
INSERT INTO nullables VALUES (NULL);
explain
SELECT count(*) FROM covered WHERE m NOT IN ('sad', 'ok', 'happy');
SELECT count(*) FROM covered WHERE m NOT IN ('sad', 'ok', 'happy');
explain
SELECT count(*) FROM nullables WHERE m NOT IN ('sad', 'ok', 'happy');
SELECT count(*) FROM nullables WHERE m NOT IN ('sad', 'ok', 'happy');
explain
SELECT random() FROM covered WHERE m NOT IN ('sad', 'ok', 'happy');
explain
SELECT random() FROM nullables WHERE m NOT IN ('sad', 'ok', 'happy');
explain
DELETE FROM covered WHERE m NOT IN ('sad', 'ok', 'happy');
