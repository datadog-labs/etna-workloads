# Rationale

Fix: the debug-only fts5 integrity-check (`fts5TestTerm`) gave a spurious
FTS5_CORRUPT when an index term was malformed utf-8 (a truncated lead byte
that is a prefix of a valid char). The fix skipped the NOIDX prefix check
unless `fts5TestUtf8(zTerm, nTerm)==0`.

## Hunks changed (ext/fts5/fts5_index.c)

1. `fts5TestTerm`: `if( p->nPendingData==0 && 0==fts5TestUtf8(zTerm, nTerm) )`
   -> `if( p->nPendingData==0 )`. Reverses the fix's second hunk (the added
   utf-8 validity guard). `fts5TestUtf8` is left defined but unused.
2. `sqlite3Fts5IndexCharlenToBytelen`: `if( n>=nByte ) return 0;` after a lead
   byte -> `if( n>=nByte ) break;`. Reversing hunk 1 alone does not reproduce the
   bug on 3.54.1: this later code already refuses to write a prefix-index
   entry for a trailing lone lead byte (returns 0), so the main-vs-prefix
   index mismatch never arises. This is the second path covering the same
   defect (malformed trailing utf-8 / prefix index). With `break`, the lone
   byte `\xe4` is again written as a 1-char prefix term, as before; the
   loop's later `n>=nByte` check still returns 0 when more chars were wanted,
   and no out-of-bounds read happens.

## Oracle failure
`fts5misc-10.2` (`INSERT INTO vt1(vt1) VALUES('integrity-check')` on
`vt1(c1,c2,prefix=1,tokenize=ascii)` holding x'e4' and '䔬') fails with a
corruption error: the prefix term `\xe4` in the prefix index has one doclist
entry, but the NOIDX scan of the main index for prefix `\xe4` also matches
`\xe494ac`, so the checksums differ.
