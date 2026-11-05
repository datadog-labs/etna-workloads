\set VERBOSITY terse
SELECT * FROM XMLTABLE (ROW () PASSING null COLUMNS v1 timestamp __pg__is_not_null 1) AS f (v1);
