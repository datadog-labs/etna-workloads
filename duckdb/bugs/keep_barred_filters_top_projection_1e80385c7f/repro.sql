CREATE TABLE mixed AS SELECT i, CASE WHEN i % 100 >= 50 THEN i::VARCHAR ELSE 'hidden_' || i END AS s FROM range(200) t(i);
CREATE SECURE VIEW visible_modulo AS SELECT * FROM (SELECT i, s FROM mixed) WHERE i % 100 >= 50;
SELECT count(*) FROM visible_modulo WHERE s::INT > 0;
