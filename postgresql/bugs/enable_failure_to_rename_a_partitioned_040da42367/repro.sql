CREATE ROLE regress_r1;
CREATE TABLE part_attmp (a int primary key) partition by range (a);
SET ROLE regress_r1;
ALTER INDEX part_attmp_pkey RENAME TO fail;
RESET ROLE;
DROP TABLE part_attmp;
DROP ROLE regress_r1;
