# Rationale

Fix hunk reversed: `sqlite3Fts3Snippet()` clamping nToken to [-64,64].
In 3.54.1 the clamp lives in the caller, `fts3SnippetFunc()` (ext/fts3/fts3.c), with
a matching assert in `sqlite3Fts3Snippet()` (ext/fts3/fts3_snippet.c).

- fts3.c: removed the two clamp lines (`if( nToken<-64 )...`, `if( nToken>64 )...`).
  Same defect as the fix's missing clamp: snippet length is no longer limited to 64 tokens.
- fts3_snippet.c: removed the "already limited to 64 tokens" assert, which did not exist pre-fix.

The other fix hunks only add asserts, so they are left as is; they are what detects the bug.

Oracle: fts3snippet-4.3 (`snippet(t4,'','','',0,150)`) fails with the assertion
`(nSnippet-1-nRight)<=63` in fts3SnippetShift (undefined left shift by >63).
