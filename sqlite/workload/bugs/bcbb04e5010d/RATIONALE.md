# Rationale

Fix (CVS 4040, ticket #2391) replaced, in `findTerm()` (where.c), the ad-hoc
"collseq of left, else collseq of right" lookup with
`sqlite3BinaryCompareCollSeq()`, which honours an explicit COLLATE clause on
either side. In 3.54.1 `findTerm` became `whereScanNext()` and uses
`sqlite3ExprCompareCollSeq()` (a wrapper over `sqlite3BinaryCompareCollSeq`).

## Changed hunk: src/where.c, whereScanNext(), non-IN branch
Reverts the where.c hunk of the fix: the index-match collation is again
computed as `sqlite3ExprCollSeq(pLeft)`, falling back to
`sqlite3ExprCollSeq(pRight)` if null, instead of
`sqlite3ExprCompareCollSeq(pParse, pX)`. This ignores an explicit COLLATE on
the right operand when the left column has its own collation, so an index on
the column (BINARY) is wrongly used for `col < 'x' COLLATE nocase`.
The expr.c/sqliteInt.h hunks (renaming/exporting the helper) are not reverted;
the helper still exists and is used elsewhere.
Only the non-IN branch is changed (IN did not exist as such in 2007).

## Oracle
test/tkt2391.test: tkt2391.4 fails (expected 2, got 1) — the index silently
overrides `COLLATE nocase`. Cases .1–.3 (no index) still pass.
