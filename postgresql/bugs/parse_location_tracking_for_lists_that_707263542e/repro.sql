CREATE SCHEMA IF NOT EXISTS s1
  CREATE TABLE abc (a int);
create table u(i int unique);
ALTER TABLE u ALTER CONSTRAINT u_i_key NOT VALID;
