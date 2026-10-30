Reproducer for the ZINTERSTORE #516 regression: the intset iterator in zuiNext no longer stores the element value.

repro.sh creates two intset sets and one small zset, then runs ZINTERSTORE with WEIGHTS 0 0 1 and ZRANGE on the result.

Clean build: ZINTERSTORE returns 1 and ZRANGE returns `100`.
Buggy build: ZINTERSTORE returns 0 and ZRANGE returns nothing.
