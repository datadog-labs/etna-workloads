CREATE FUNCTION h() RETURNS fdw_handler LANGUAGE internal AS $$pg_is_in_recovery$$;
CREATE FOREIGN DATA WRAPPER w HANDLER h;
ALTER FOREIGN DATA WRAPPER w VALIDATOR postgresql_fdw_validator;
DROP FUNCTION h();
SELECT fdwhandler <> 0 AS has_handler FROM pg_foreign_data_wrapper WHERE fdwname='w';
