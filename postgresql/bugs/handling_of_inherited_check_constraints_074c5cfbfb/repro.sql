CREATE TABLE test_inh_check (a float check (a > 10.2), b float);
CREATE TABLE test_inh_check_child() INHERITS(test_inh_check);
ALTER TABLE test_inh_check ALTER COLUMN a TYPE numeric;
select relname, conname, coninhcount, conislocal, connoinherit
  from pg_constraint c, pg_class r
  where relname like 'test_inh_check%' and c.conrelid = r.oid
  order by 1, 2;
