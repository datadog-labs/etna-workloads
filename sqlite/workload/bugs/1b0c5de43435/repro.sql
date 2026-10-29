CREATE TABLE xxx(a, b, c);
CREATE VIEW vvv AS SELECT a AS d FROM xxx WHERE d=0;
ALTER TABLE xxx RENAME a TO xyz;
SELECT sql FROM sqlite_master WHERE type='view';
