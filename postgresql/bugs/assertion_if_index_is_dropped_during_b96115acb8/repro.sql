CREATE FUNCTION mvtest_drop_the_index() RETURNS bool AS $$
BEGIN
  EXECUTE 'DROP INDEX IF EXISTS public.mvtest_drop_idx';
  RETURN true;
END;
$$ LANGUAGE plpgsql;
CREATE MATERIALIZED VIEW drop_idx_matview AS
  SELECT 1 as i WHERE mvtest_drop_the_index();
CREATE UNIQUE INDEX mvtest_drop_idx ON drop_idx_matview (i);
CREATE TABLE res(m text);
DO $$ BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY drop_idx_matview;
EXCEPTION WHEN OTHERS THEN INSERT INTO res VALUES (SQLERRM);
END $$;
SELECT * FROM res;
