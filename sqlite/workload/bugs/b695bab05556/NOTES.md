`repro.sql` builds an FTS3 table, injects a corrupt segment into `def_segdir` (needs `.dbconfig defensive off`), then runs `MATCH '1 NEAR 1'`. It is test fts3corrupt4-43.2.

- Clean shell: prints `1`, exit 0.
- Buggy shell: aborts on assertion `pPhrase->doclist.pList[nNew]=='\0'` in `fts3EvalNearTrim`.
  Without the fix's `nNew>=0` guard, a corrupt doclist makes `nNew` out of range.
