repro.sql is the join2-7.0 case: a LEFT JOIN whose right operand is a subquery, with `c IS NULL` in the outer WHERE.
The bug is in the push-down optimization. The buggy shell pushes the WHERE term into the LEFT JOIN's right-hand subquery. That gives wrong rows.
The clean shell returns `3|4||||x` and `5|6||||x`. The buggy shell returns a different result, which `./check.sh` shows.
