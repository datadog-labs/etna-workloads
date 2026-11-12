CREATE SEQUENCE s;
SELECT NOT (nextval('s') > 0 AND nextval('s') > 0);
SELECT currval('s');
