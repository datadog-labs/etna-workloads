# Rationale

Hunk reversed: `zipfileBegin()` in `ext/misc/zipfile.c`. The fix changed
`if( pTab->zFile==0 ) return SQLITE_OK;` to raise "zipfile: missing filename"
(SQLITE_ERROR) when zFile is NULL or empty. In 3.54.1 that check used
`zipfileTableErr()`, with otherwise identical logic. I restored the original
one-line early return, so a write to a zipfile table with no filename silently
succeeds again instead of failing at xBegin.

Oracle failures: zipfile-16.10 (expects `1 {zipfile: missing filename}`, got
`1 {zipfile() function requires an argument}`), and zipfile-16.20 (the
REPLACE with a NULL name no longer reports the error).
