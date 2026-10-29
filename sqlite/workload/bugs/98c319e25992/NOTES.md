repro.sql: a TEXT column '07777' is grouped, then used on the left of `IN (SELECT int_pk ...)`
in the select list, and the column is also selected again.
The buggy shell applies the INTEGER affinity in place to the shared TK_AGG_COLUMN register,
so the later `t1.a` returns `7777`. The clean shell copies the register first and returns `07777`.
Output: clean `07777|1|07777`, buggy `07777|1|7777`.
