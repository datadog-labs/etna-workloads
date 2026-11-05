CREATE TABLE rule_t1(a int, b text DEFAULT 'xxx', c int);
CREATE VIEW rule_v1 AS SELECT * FROM rule_t1;
CREATE RULE v1_ins AS ON INSERT TO rule_v1
  DO ALSO INSERT INTO rule_t1
  SELECT * FROM (SELECT a + 10 FROM rule_t1 WHERE a = NEW.a) tt;
CREATE RULE v1_upd AS ON UPDATE TO rule_v1
  DO ALSO UPDATE rule_t1 t
  SET c = tt.a * 10
  FROM (SELECT a FROM rule_t1 WHERE a = OLD.a) tt WHERE t.a = tt.a;
INSERT INTO rule_v1 VALUES (1, 'a'), (2, 'b');
UPDATE rule_v1 SET b = upper(b);
SELECT * FROM rule_t1;
