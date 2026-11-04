repro.sql runs starts_with(col, literal) where the literal contains `_` or `\`, on inline VALUES.
The simplifier rewrites it to LIKE. The buggy build doesn't escape `_` or `\`, so `_` acts as a wildcard
(`foobar` wrongly matches `foo_`) and `\_` matches nothing. The clean build gives the correct results.
The EXPLAIN shows `LIKE f_o%` (buggy) vs `LIKE f\_o%` (clean).
