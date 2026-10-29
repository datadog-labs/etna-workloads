# Rationale

Fix hunk (src/resolve.c, TK_NOTNULL/TK_ISNULL in resolveExprStep): added `&& !IN_RENAME_OBJECT`
so that the "<expr> NOT NULL" / "IS NULL" constant-folding is skipped during ALTER TABLE RENAME.

In 3.54.1 the fix is expressed as `if( IN_RENAME_OBJECT ) return WRC_Prune;` right after walking
pExpr->pLeft. Changes to src/resolve.c:

1. Removed that `IN_RENAME_OBJECT` early return (the direct reversal of the fix hunk).
2. Removed the later `NC_Where` loop ("Not in a WHERE clause. Unsafe to optimize"). This is a
   later, independent guard that also stops the folding outside WHERE, so it masks the bug for the
   oracle's `SELECT c NOT NULL FROM t1` (no WHERE). Without removing it, reversing (1) alone leaves
   no oracle failure. This is the same defect: folding happens during rename when it shouldn't.

Oracle failures: altercol-21.1 and altercol-21.2. With the trigger body `SELECT c NOT NULL`,
the NOT NULL is folded to an integer during rename resolution, so the column reference is
dropped and the rename does not rewrite `c` to `d` in the trigger (21.1 errors / 21.2 shows
the old `c` text).
