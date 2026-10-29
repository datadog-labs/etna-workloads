Inserts a row with a NULL name (column `a`) into a `zipfile` virtual table (test zipfile-13.10).
Clean shell: row inserted, prints `''|2`, exit 0.
Buggy shell: zipfileUpdate calls strlen() on a NULL path, so the shell segfaults (exit 139).
