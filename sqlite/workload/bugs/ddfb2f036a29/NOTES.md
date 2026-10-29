Running a pragma that names the temp database (`PRAGMA temp.cache_size = 400`) on a fresh connection, before temp is open.
Clean: the temp db is opened first, so the pragma works and prints 400.
Buggy: the open is missing, so every statement fails with "SQL logic error" and the shell exits 1.
