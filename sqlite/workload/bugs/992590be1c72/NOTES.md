`repro.sql` runs an INSERT ... SELECT whose compound SELECT uses an unknown collation (`5 COLLATE xyzzy`).
Clean shell: "no such collation sequence: xyzzy" error, exit 1.
Buggy shell: assertion failure `pParse->nErr==0 || rc` in sqlite3Insert (abort, exit -6).
