.mode list
.nullvalue NULL
CREATE SEQUENCE seq START 1;
SELECT nextval('seq');
PREPARE stmt AS SELECT currval(concat('se', 'q'));
EXECUTE stmt;
DROP SEQUENCE seq;
EXECUTE stmt;
CREATE SEQUENCE seq START 10;
SELECT nextval('seq');
EXECUTE stmt;
