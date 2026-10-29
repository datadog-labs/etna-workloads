# Rationale (ticket #3493)

The fix added `TK_AGG_COLUMN` to the column cases of `sqlite3ExprAffinity()` and `sqlite3ExprCollSeq()` in src/expr.c. In 3.54.1 both already handle it (guarded by `y.pTab!=0`), so I removed it from both:

- `sqlite3ExprAffinity`: `if( op==TK_COLUMN || (op==TK_AGG_COLUMN && ...) )` is now `if( op==TK_COLUMN )`. This reverses the first fix hunk.
- `sqlite3ExprCollSeq`: `(op==TK_AGG_COLUMN && p->y.pTab!=0) || op==TK_COLUMN || op==TK_TRIGGER` is now `op==TK_COLUMN || op==TK_TRIGGER`. This reverses the second fix hunk.

Comparisons over aggregate-query columns therefore lose the column's affinity and collation again.

Oracle cases that fail (8 of 27): tkt3493-2.2.1, 2.2.4, 2.3.1, 2.3.3, 2.4.2, 2.5.1, 3.2.1, 3.3.1. For example, `SELECT a=123 FROM t1 GROUP BY a` no longer applies TEXT affinity, and the NOCASE collation is ignored in `a='abc'` under GROUP BY.
