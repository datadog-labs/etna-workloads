CREATE TABLE test_inh_check (a float check (a > 10.2));
CREATE TABLE test_inh_check_child() INHERITS(test_inh_check);
ALTER TABLE test_inh_check ALTER COLUMN a TYPE numeric;
\d test_inh_check_child
