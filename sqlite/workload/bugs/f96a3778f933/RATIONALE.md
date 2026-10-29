# Rationale

Fix hunk reversed: `src/parse.y`, `ccons ::= DEFAULT MINUS term`. The fix added
the span of the whole `-term` expression (starting at the MINUS token) to the
UMINUS expression so `PRAGMA table_info` reports the original text. (The
`pragma.c` notNull hunk is cosmetic and not reverted.)

In 3.54.1 the span is passed to `sqlite3AddDefaultValue(pParse,p,zStart,zEnd)`.
The change makes the span cover only the `-` token (`A.z .. &A.z[A.n]`) instead of
`A.z .. &Z.z[Z.n]` (through the end of the term), so the negative default's text
is lost (reported as `-` rather than `-1`). Same defect class: the span of
the negative default doesn't cover the number. (`scantok(Z)` label became unused, so
dropped.)

Oracle failure: `pragma-6.7` (`one INT NOT NULL DEFAULT -1` expected `-1`, gets `-`).
