\set VERBOSITY default
CREATE TEMP TABLE pk (a int primary key);
CREATE TEMP TABLE fk (b inet);
ALTER TABLE fk ADD FOREIGN KEY (b) REFERENCES pk;
