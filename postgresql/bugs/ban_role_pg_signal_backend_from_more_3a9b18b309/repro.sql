CREATE ROLE r_sig;
GRANT pg_signal_backend TO r_sig;
CREATE FUNCTION terminate_nothrow(pid int) RETURNS bool
	LANGUAGE plpgsql SECURITY DEFINER SET client_min_messages = error AS $$
BEGIN
	RETURN pg_terminate_backend($1);
EXCEPTION WHEN OTHERS THEN
	RETURN false;
END$$;
ALTER FUNCTION terminate_nothrow OWNER TO r_sig;
SELECT backend_type FROM pg_stat_activity
WHERE CASE WHEN COALESCE(usesysid, 10) = 10 THEN terminate_nothrow(pid) END
ORDER BY 1;
