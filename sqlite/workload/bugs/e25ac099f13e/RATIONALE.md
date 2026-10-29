# Rationale

## Changed hunk
`ext/fts3/fts3.c`, `fts3TermSelectMerge()`: when the first non-empty doclist is
found at index `i`, the code now clears `pTS->aaOutput[0]` instead of
`pTS->aaOutput[i]`. This reverses the fix hunk
`-  pTS->aaOutput[0] = 0;  +  pTS->aaOutput[i] = 0;`, so it is the same line as in the fix.

Effect: if the first populated slot is `i>0`, `aaOutput[i]` still points at the
buffer that was moved into `aOut`. After `aaOutput[0] = aOut`, the same buffer is
owned by two slots, and the cleanup loop in `sqlite3Fts3SegReaderCursor`/term-select
frees it twice (double free).

## Other fix hunks
The `fts3CreateTables`, `fts3SelectLeaf` and `fts3PhraseSelect` hunks were not
reverted. `bHasContent` handling was redesigned, the `fts3SelectLeaf` change is
only an assert plus an OOM/error check, and `fts3PhraseSelect` no longer exists.

## Oracle failures
`test/fts3fault.test` (prefix-query OOM test 3 and later) aborts with
`free(): double free detected in tcache 2`, so the remaining cases in that
file never run and are counted as failing.
