CREATE TABLE trgfire (i int) PARTITION BY RANGE (i);
CREATE TABLE trgfire1 PARTITION OF trgfire FOR VALUES FROM (1) TO (10);
CREATE FUNCTION tgf() RETURNS trigger LANGUAGE plpgsql
  AS $$ begin raise exception 'except'; end $$;
CREATE TRIGGER tg AFTER INSERT ON trgfire FOR EACH ROW EXECUTE FUNCTION tgf();
ALTER TABLE trgfire DISABLE TRIGGER tg;
CREATE TABLE trgfire2 PARTITION OF trgfire FOR VALUES FROM (10) TO (20);
CREATE TABLE trgfire3 (LIKE trgfire);
ALTER TABLE trgfire ATTACH PARTITION trgfire3 FOR VALUES FROM (20) TO (30);
SELECT tgrelid::regclass, tgenabled FROM pg_trigger
  WHERE tgrelid::regclass::text LIKE 'trgfire%' ORDER BY 1::text, 2;
INSERT INTO trgfire VALUES (11);
INSERT INTO trgfire VALUES (21);
