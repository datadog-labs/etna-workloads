# Rationale

Fix hunks (ext/fts5/fts5_aux.c, fts5SnippetScore) reversed:
1. Removed the `int iLast = 0;` declaration and the `iLast = iOff + xPhraseSize(ip)` assignment inside the loop (which only tracked instances within the window).
2. Restored `int iLast = iOff + pApi->xPhraseSize(pFts, ip);` inside `if( piPos )` after the loop. This uses `ip`/`iOff` from the last instance examined by the loop, even if it fell outside [iPos, iEnd), so the snippet start is adjusted using a bogus end and can yield text with zero phrase instances.

The rest of the function (sqlite3_int64 iAdj, iEnd) is unchanged modern code.

Failing oracle cases: fts5af-{full,col,none}-5.1 through 5.6 (snippet() results differ from expected).
