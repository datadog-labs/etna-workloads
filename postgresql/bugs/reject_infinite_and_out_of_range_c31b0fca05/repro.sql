CREATE FUNCTION t(i interval) RETURNS text LANGUAGE plpgsql AS $$
BEGIN PERFORM uuidv7(i); RETURN 'accepted'; EXCEPTION WHEN OTHERS THEN RETURN SQLERRM; END $$;
SELECT t('infinity'), t('-infinity'), t('-1000 years'), t('9000 years');
