## Bug

`zipfileBegin()` only checked `pTab->zFile==0` before opening the backing
file for writing. The fix (2020-01-03) also rejects an empty-string filename
(`pTab->zFile[0]==0`), raising `zipfile: missing filename` immediately.

With the bug present, the eponymous `zipfile` virtual table (created with no
filename argument, so `zFile` is `""`, not `NULL`) lets a write proceed
instead of erroring out, which crashes.

## Reproducer

`repro.sql` runs on the eponymous `zipfile` table (no filename given):

```sql
DELETE FROM zipfile;
REPLACE INTO zipfile VALUES(null,null,null,null,null,123,null);
```

- `sqlite3-clean`: both statements correctly error with
  `zipfile: missing filename`; exit status 1.
- `sqlite3-buggy`: the first `DELETE` reports the old, pre-fix error
  (`zipfile() function requires an argument`), and the second `REPLACE`
  segfaults (exit status -11) instead of erroring.

This covers test cases zipfile-16.10 and zipfile-16.20 from
`test/zipfile.test`.
