`repro.sh` creates a zipfile virtual table and inserts a row with `data` NULL and no `mode` (a directory).

- clean: the entry gets the directory default mode, so it reads back as `dirname2/|16877|`.
- buggy: the default mode is the regular-file one, so it reads back as `dirname2/|33188|`.
