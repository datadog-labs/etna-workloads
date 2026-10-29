# Rationale

Fix: add SQLITE_PREPARE_NO_VTAB and propagate it (via `Parse.disableVtab`) into
trigger sub-programs, so a trigger on an FTS shadow table cannot reference the
virtual table and create a circular reference (resource leak).

In 3.54.1 the flag lives in `Parse.prepFlags`; `sqlite3LocateTable()` already checks it
(build.c), and FTS3/FTS5/rtree pass the flag. Of the fix's hunks only the trigger
one has no unchanged equivalent to reverse, so only that one is reverted.

## Changed hunk
`src/trigger.c`, `codeRowTrigger()`: removed `sSubParse.prepFlags = pParse->prepFlags;`.
This reverses the fix's `pSubParse->disableVtab = pParse->disableVtab;`. Without it,
trigger bodies are compiled without NO_VTAB, so the trigger on `z1_content`
(`DELETE FROM z1`) can resolve the virtual table `z1`.

## Oracle result
`fts3aa-10.1` fails: expected `1 {SQL logic error}`, got
`1 {bad parameter or other API misuse}`, and testfixture reports unfreed memory
(the leak the fix targeted). All other cases pass.
