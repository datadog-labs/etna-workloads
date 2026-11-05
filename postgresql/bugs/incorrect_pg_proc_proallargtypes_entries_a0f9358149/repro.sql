SELECT oid::regprocedure, pg_get_function_arguments(oid) FROM pg_proc WHERE oid IN (3078, 3839) ORDER BY oid;
