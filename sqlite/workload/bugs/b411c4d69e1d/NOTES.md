Reproducer (repro.sql): a virtual generated column `a` in t1 is indexed, and t1 is
the right side of `t2 NATURAL RIGHT JOIN t1`. Taken from joinH-13.2.

Clean shell returns `123`. The buggy shell returns no rows, because the
virtual-column indexed expression is no longer flagged bMaybeNullRow for outer joins.
