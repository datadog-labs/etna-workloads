repro.sql runs `DROP TABLE dbstat;` (an eponymous virtual table) and then `PRAGMA table_info=dbstat;`.

Clean shell: the DROP fails with "table dbstat may not be dropped", and table_info still lists the dbstat columns (exit 1).
Buggy shell: injection.patch removes the TF_Eponymous check, so the DROP reaches sqlite3VtabCallDestroy and aborts on an assertion (`Assertion `0' failed`, exit -6).
