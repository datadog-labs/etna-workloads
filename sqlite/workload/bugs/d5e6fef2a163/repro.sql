ATTACH ':memory:' AS aux;
CREATE TABLE aux.t1(a, b, c);
CREATE TABLE main.t1(a, b, c);
CREATE TEMP TRIGGER tr AFTER INSERT ON aux.t1 BEGIN
  SELECT new.a, new.b, new.c;
END;
ALTER TABLE main.t1 RENAME TO t2;
SELECT name, tbl_name FROM sqlite_temp_master;
ALTER TABLE aux.t1 RENAME TO t2;
SELECT name, tbl_name FROM sqlite_temp_master;
INSERT INTO aux.t2 VALUES(7, 8, 9);
