# Rationale

Fix 53bf7175 (omit-table-from-left-join, OSSFuzz): when a LEFT JOIN loop is
dropped, its bit must be cleared from `notReady` and the WHERE terms that
depend on it must be marked TERM_CODED. Before the fix neither happened.

In 3.54.1 this logic lives in `whereOmitNoopJoin()` (src/where.c). The change
removes from that function:

- `notReady &= ~pLoop->maskSelf;` reverses the fix hunk that added the same
  line (and moved the `notReady = ~0` initialisation before the omission).
  Without it the omitted loop's cursor stays "not ready", so later
  loops (automatic-index construction) see terms referencing the dropped table.
- the loop setting `TERM_CODED` (and `prereqAll = 0`) on terms that depend
  on the dropped loop; reverses the fix hunk adding the TERM_CODED loop.
  I also removed the `prereqAll = 0` assignment, which is the modern form of
  the same bookkeeping and would otherwise partly mask the bug.

The caller's `notReady = ~(Bitmask)0` initialisation is unchanged; it already
precedes the omission, which is equivalent to the fix's relocation.

## Oracle result
join2-4.3.0 fails: `constructAutomaticIndex: Assertion nKeyCol>0 failed`
(the OSSFuzz assertion fault the fix's test targets). The test run aborts there.
