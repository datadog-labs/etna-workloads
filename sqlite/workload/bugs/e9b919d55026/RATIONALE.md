# Rationale

Fix: FTS5 tokenizer constructors (ascii, unicode61, trigram) looped `i<nArg; i+=2`
reading `azArg[i+1]`, which overruns with an odd argument count (e.g. `trigram case_sensitive`).
In 3.54.1 the fix's `i<nArg-1` / `if( i<nArg )` hunks are covered by a later, separate guard:
`if( nArg%2 ){ rc = SQLITE_ERROR; }else{...}` at the top of fts5AsciiCreate, fts5UnicodeCreate and
fts5TriCreate. That is the same defect path (odd-length arg list), so I removed those three guards
(ext/fts5/fts5_tokenize.c), restoring the pre-fix state: the loops (already `i<nArg`) read past the end of azArg.

Oracle: fts5trigram-2.0.1 and fts5trigram2-1.0.1 (`trigram case_sensitive` / `trigram remove_diacritics`)
crash the testfixture instead of returning "error in tokenizer constructor"; the remaining cases in those files
fail as a consequence of the incomplete run. The 'none' cases in fts5tokenizer2 still pass because
the unknown option name still errors (azArg[i+1] is read as NULL-adjacent but not dereferenced for ascii/unicode strings).
