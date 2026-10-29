repro.sql creates a main table t1 with a TEMP trigger on it, then creates a TEMP table t1.
Clean: succeeds; sqlite_temp_master lists tr1 and t1, exit 0.
Buggy: CREATE TEMP TABLE reparses all temp entries with tbl_name='t1' (including the trigger), giving
"malformed database schema (tr1) - trigger tr1 already exists", exit 1.
