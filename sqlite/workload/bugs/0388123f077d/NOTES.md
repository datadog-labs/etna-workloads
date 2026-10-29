repro.sql creates a table with a UNIQUE column, then runs ALTER TABLE ADD COLUMN with UNIQUE and with PRIMARY KEY.

Clean shell: both statements fail with "Cannot add a UNIQUE column" and "Cannot add a PRIMARY KEY column".
Buggy shell: the new-table copy no longer has the "sqlite_altertab_" prefix. An assertion fails in deleteTable (`pOld==pIndex || pOld==0`) and the shell aborts.
