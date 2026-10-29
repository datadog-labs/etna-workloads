Reproducer for the fts3aux/fts5vocab binary-collation fix (fts3aux2-4.2).
Query on an fts4aux table filters `term COLLATE NOCASE = 'ABC'` while joining on t0.c0 = t1.term.
Correct (clean) shell prints 2; the buggy shell treats the NOCASE constraint as a binary equality and returns a different count.
