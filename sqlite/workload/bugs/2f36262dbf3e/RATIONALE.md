# Rationale

Fix hunk (ext/fts5/fts5_index.c, fts5WriteAppendRowid): `assert( ... )` -> `assert_nc( ... )`.
Reversed at tree/ext/fts5/fts5_index.c:4588 by turning `assert_nc` back into `assert`.
The surrounding code was rewritten (u64 cast), but the assert line is unchanged otherwise, so the revert is exact.
With a corrupt database the rowids are not increasing, so the assert fires instead of the corruption being reported.

Failing oracle case: fts5corrupt3-23.1 (`INSERT INTO t1(t1) VALUES('optimize')` on the corrupt db)
aborts with `Assertion 'p->rc || iRowid>pWriter->iPrevRowid' failed` instead of returning
`database disk image is malformed`.
