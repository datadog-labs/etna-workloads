CREATE COLLATION ci (provider = icu, deterministic = false, locale = 'und-u-ks-level2');
CREATE TABLE pk (x text COLLATE "C" PRIMARY KEY);
CREATE TABLE fk (x text COLLATE ci REFERENCES pk (x));
CREATE TABLE pk2 (x text COLLATE ci PRIMARY KEY);
CREATE TABLE fk2 (x text COLLATE "C" REFERENCES pk2 (x));
