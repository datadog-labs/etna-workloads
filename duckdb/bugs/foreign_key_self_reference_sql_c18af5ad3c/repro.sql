.mode list
.nullvalue NULL
CREATE TABLE t(id INT PRIMARY KEY, parent INT REFERENCES t(id));
SELECT constraint_type, constraint_text
FROM duckdb_constraints()
WHERE table_name = 't' AND constraint_type = 'FOREIGN KEY';
