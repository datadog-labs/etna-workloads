CREATE FUNCTION invert(x float8) RETURNS float8 LANGUAGE plpgsql AS
$$ begin return 1/x; end $$;
CREATE FUNCTION create_temp_tab() RETURNS text
LANGUAGE plpgsql AS $$
BEGIN
  CREATE TEMP TABLE new_table (f1 float8);
  INSERT INTO new_table SELECT invert(0.0);
  RETURN 'foo';
END $$;
BEGIN;
DECLARE ctt CURSOR FOR SELECT create_temp_tab();
SAVEPOINT s1;
FETCH ctt;
ROLLBACK TO s1;
FETCH ctt;
COMMIT;
