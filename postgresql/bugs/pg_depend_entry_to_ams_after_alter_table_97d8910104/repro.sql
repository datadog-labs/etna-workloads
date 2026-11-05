CREATE ACCESS METHOD heap2 TYPE TABLE HANDLER heap_tableam_handler;
CREATE TABLE heaptable (a int);
ALTER TABLE heaptable SET ACCESS METHOD heap2;
SELECT pg_describe_object(refclassid, refobjid, refobjsubid) AS objref
  FROM pg_depend WHERE classid='pg_class'::regclass AND objid='heaptable'::regclass ORDER BY 1;
DROP ACCESS METHOD heap2;
