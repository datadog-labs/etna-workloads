`repro.sql` runs `VALUES(2) EXCEPT SELECT '' ORDER BY abc;`. The VALUES term of the compound has a NULL result-column name. The buggy build passes it to `sqlite3_stricmp` instead of `sqlite3StrICmp`, which dereferences NULL.

- clean: `Parse error near line 1: 1st ORDER BY term does not match any column in the result set`, exit 1.
- buggy: segfault, exit 139.
