CREATE TABLE t1(a,b,c,d);
CREATE TABLE t2(a,b,c,d,x);
CREATE TRIGGER AFTER INSERT ON t2 BEGIN
  SELECT group_conct(
      123 ORDER BY (
        SELECT 1 FROM ( VALUES(a, 'b'), ('c') )
        ))
  FROM t1;
END;
ALTER TABLE t2 RENAME TO newname;
