Reproducer: repro.sh creates a non-empty dest.db, then runs `.restore main empty.db`
(a backup from a zero-byte source file) and prints the resulting size of dest.db.

Clean shell: dest.db ends up one page (4096 bytes here). Buggy shell: the backup
truncates it to 0 bytes, resetting the schema cookie and change counter (backup4-2.3/3.3).
