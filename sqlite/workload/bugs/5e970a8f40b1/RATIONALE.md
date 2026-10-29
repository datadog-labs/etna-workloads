# Rationale

## Changed hunk: src/resolve.c, resolveCompoundOrderBy()

The fix made the ORDER BY term be resolved in place (not only on a duplicate)
under IN_RENAME_OBJECT, so alter.c can see and rename column references in the
ORDER BY of a compound SELECT inside a view/trigger. In 3.54.1 that logic is
expressed differently: the duplicate `pDup` is resolved, and if it matches
(`iCol>0`) under IN_RENAME_OBJECT the real expression `pE` is resolved too.
I removed that second `resolveOrderByTermToExprList(pParse, pSelect, pE)` call,
restoring the pre-fix behaviour where only the throwaway duplicate is resolved.
The real ORDER BY expression keeps unresolved column references, so rename
never updates them.

## Oracle failures
- altertab2-6.2: `ALTER TABLE t3x RENAME a TO abcd` fails with
  "error in trigger r3 after rename: 1st ORDER BY term does not match any column in the result set"
  (the fix's own new test).
- altertab2-7.3: similar error for trigger r1 (2nd ORDER BY term).
