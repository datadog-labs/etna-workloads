# Rationale

Fix hunk reversed: src/select.c in sqlite3Select(), the "tag-select-0100" block.
The fix replaced `IgnorableOrderby(pDest)` with `IgnorableDistinct(pDest)` as the
condition for dropping ORDER BY *and* clearing SF_Distinct, because SRT_Queue and
SRT_Fifo (recursive CTE destinations) honor ORDER BY-ignorability but must not
lose DISTINCT. In 3.54.1 the macros `IgnorableDistinct`/`IgnorableOrderby` and the
SRT_ ordering in sqliteInt.h are already in the fixed form, so I only changed the
condition back to `IgnorableOrderby(pDest)` (and restored the pre-fix assert listing
SRT_Queue/SRT_Fifo, which would otherwise fire). The sqliteInt.h hunk (enum
reordering) needs no change: IgnorableOrderby is still defined and is the
broader range including Queue and Fifo.

Failing oracle cases (test/with1.test): with1-26.1 (duplicate rows from the
recursive CTE's initial SELECT DISTINCT are kept: `a 1 a 1 a 2 a 2 ...`) and
with1-26.3 (DISTINCT in the recursive part ignored, extra duplicate rows).
