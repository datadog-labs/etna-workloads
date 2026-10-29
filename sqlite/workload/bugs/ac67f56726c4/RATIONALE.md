# Rationale

Fix: ALTER TABLE RENAME looped forever on CTE cycles in the schema. The fix
added SF_CopyCte (set on the CTE copy made in resolveFromTermToCte) and made
the three rename walker callbacks prune such selects.

## Changes
1. `src/alter.c` renameUnmapSelectCb, renameColumnSelectCb, renameTableSelectCb:
   prune only on `SF_View` again, not `SF_View|SF_CopyCte`. Reverses the three
   alter.c hunks. The SF_CopyCte flag and its setter in select.c remain
   (the flag is also used by the count(*) optimisation), so only the pruning is lost.
2. `src/select.c` resolveFromTermToCte: removed the
   `if( checkSubqueryNestingDepth(pParse) ) return 2;` call after
   `pParse->nNestSel++`. Reverting (1) alone does not reproduce the bug,
   because 3.54.1 has a later, second guard (2026-10-04, nested CTE depth limit)
   that bounds the recursion (about 3000 walker callbacks, then silently stops).
   That guard also stops the same unbounded CTE-copy recursion, so it is the
   "fixed twice" path; removing it restores the original behaviour.

## Oracle failure
test/altertab.test 31.2 (`ALTER TABLE t1 RENAME TO t1x` with the view
`WITH x AS (WITH y AS (SELECT * FROM x) SELECT 1) SELECT 1`) now recurses
without bound and the testfixture crashes (stack overflow), so 31.2 and 31.3
fail. 31.0 and 31.1 and all earlier cases still pass.
