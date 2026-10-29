# Rationale

The fix backed out the optimization of check-in b67a6e33f2: the 2nd and later
sub-queries of the OR optimization reused the previous OP_OpenRead on the index
cursor instead of emitting their own. It broke when an OR term was AND-ed with
a constant expression, e.g. `(1=2 AND a=3) OR a=4`. The first term's code,
including its OpenRead, was jumped over, so the later term used an unopened cursor.

Version 3.54.1 no longer has WHERE_OR_INDEX_OPEN or WHERE_ONETABLE_ONLY. The
sub-queries emit OP_ReopenIdx on the shared cursor `iAuxArg` instead. Only one
hunk was changed, in `src/where.c` (`sqlite3WhereBegin`, the
`WHERE_OR_SUBCLAUSE` index branch). It reverses the fix hunk that removed the
`pOp` search loop in the `WHERE_ONETABLE_ONLY` branch. It scans backward for an
earlier OP_ReopenIdx on the same cursor, and if that one has the same root page
it sets `op = 0` so no open is emitted. The scan, the root-page comparison and
the omitted open are the same as in the old code. The old
`WHERE_OR_INDEX_OPEN` flag, `subWctrlFlags` and the `pCov` assignment are not
restored. The backward scan is bounded by address 0, so it needs no flag to
guarantee termination.

## Oracle
`where2-13.1` (`SELECT * FROM t13 WHERE (1=2 AND a=3) OR a=4`) now fails. It
hits the assertion `pC!=0` in sqlite3VdbeExec because the cursor was never opened.
