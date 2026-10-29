# Rationale

Fix: restriction (6) (RIGHT JOIN ON/USING filter must not move to the other side) was moved from pushDownWhereTerms() into sqlite3ExprIsSingleTableConstraint() so that automatic-index (partial index) and Bloom-filter code also obey it. Pre-fix, only push-down had it.

Changes (reverting that move):
- src/expr.c: removed the (6a)/(6b) block from sqlite3ExprIsSingleTableConstraint() (the hunk adding it). The auto-index (where.c) and Bloom filter callers lose the check again.
- src/select.c: moved the `#if 0` so the old restriction (9) block is live again in pushDownWhereTerms(), so push-down stays protected as before the fix. (Reverses the hunk that wrapped it in `#if 0`.)

The signature changes (SrcList*, iSrc) and where.c plumbing are kept; they are needed by the other rules and are harmless without the check.

Oracle: pushdown-5.0 fails (returns an empty result instead of `- - 3 4 5`), since the ON-null filter of t1 JOIN t2 gets moved into the auto-index/Bloom filter of t4/t5 side wrongly.
