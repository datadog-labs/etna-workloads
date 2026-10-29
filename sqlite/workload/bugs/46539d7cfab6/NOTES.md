Creates triggers (normal and TEMP) whose WHEN clause contains a `?` variable.
Clean shell: "trigger cannot use variables" error for both. Buggy shell: the
WHEN clause is no longer checked, so the triggers are created silently
(the final SELECT lists tr1; the TEMP trigger lives in sqlite_temp_master).
