repro.sql creates a table where trailing `CONSTRAINT name` clauses follow column and table constraints (legacy syntax), then inserts a row that violates the CHECK.
Clean shell accepts the CREATE and reports the CHECK constraint failure on INSERT. The buggy shell gets a syntax error on the CREATE TABLE (so the INSERT then fails with "no such table").
