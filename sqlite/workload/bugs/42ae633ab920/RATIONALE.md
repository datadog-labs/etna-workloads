# Rationale

Fix: in fts5, `sqlite3_value_bytes()` must not be called before `sqlite3_value_text()`,
because the text call can convert the value (e.g. blob/UTF-16 -> UTF-8) and change its length.

Changes in `ext/fts5/fts5_storage.c` (the code has since been refactored into locale-aware
`pText`/`nText` locals, so the fix hunks do not apply verbatim):

- `sqlite3Fts5StorageRebuild()` (fix hunk 1): in the non-locale branch, `nText = sqlite3_value_bytes(pVal)`
  now runs before `pText = sqlite3_value_text(pVal)`. This restores the pre-fix ordering (bytes before text).
- `sqlite3Fts5StorageIntegrity()` (fix hunk 2): same swap for the `pText`/`nText` pair.

Other sites (fts5StorageInsertCallback-side seek at ~566, and the delete/insert path at ~1109) were
not part of the fix and are left unchanged.

## Oracle
`fts5integrity-7.1` and `fts5integrity-7.5` (integrity-check on the UTF-16 table holding blob x'46f0') fail
because the byte count is taken before the blob is converted to text, so the tokenizer
is given a mismatched length and the index doesn't match the content.
