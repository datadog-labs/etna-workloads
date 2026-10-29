repro.sh builds a hot journal (snapshot of db + journal taken mid-transaction, journal magic fixed up),
makes the journal read-only (chmod 444), and runs a SELECT. Rolling back the hot journal needs write
permission. Clean: "unable to open database file (14)" (SQLITE_CANTOPEN). Buggy: "database is locked (5)" (SQLITE_BUSY).
