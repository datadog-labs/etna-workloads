# Rationale

Fix hunk (ext/fts3/fts3.c, fts3SnippetFunc): added `else if( nToken==0 )` returning an empty string
before calling sqlite3Fts3Snippet().

In 3.54.1 that check had been merged into `else if( nToken==0 || iCol>=pTab->nColumn )`.
I removed only the `nToken==0 ||` part (keeping the later iCol check, which is unrelated), so a
0-token snippet again reaches sqlite3Fts3Snippet().

Oracle: fts3snippet-4.1 fails with `Assertion 'nFToken>0' failed` in sqlite3Fts3Snippet
(the assert the fix's message mentions); the run aborts there, so 4.2 doesn't run.
