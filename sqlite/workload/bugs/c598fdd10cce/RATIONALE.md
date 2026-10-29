# Rationale

Fix hunk: in `fts5GetTokenizer`, `*pzErr = sqlite3_mprintf("no such tokenizer...")`
became `if( pzErr ) *pzErr = ...`, so a NULL error pointer is tolerated.

In 3.54.1 that function is `sqlite3Fts5LoadTokenizer` (ext/fts5/fts5_main.c). It
reports the error through `sqlite3Fts5ConfigErrmsg()`, which checks
`pConfig->pzErrmsg` for NULL. I replaced that call with the pre-fix form, an
unconditional `*pConfig->pzErrmsg = sqlite3_mprintf(...)`, which dereferences
NULL when the config has no error-message pointer.

Oracle: fts5aux-13.4 (highlight() on a table whose tokenizer is unknown, reopened
so the tokenizer is loaded lazily with `pzErrmsg==0`). It crashes with a NULL
dereference instead of returning `1 {SQL logic error}`. The run output ends at
13.4 with no result. Cases 13.1–13.3 pass.
