CREATE TABLE t (a timetz, b timestamptz);
SELECT table_to_xmlschema('t', false, false, '');
