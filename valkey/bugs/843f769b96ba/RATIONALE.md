# Rationale

Fix hunk (src/t_zset.c, zsetAdd) reversed in both encoding branches (listpack and skiplist):
- Removed the post-INCR `GT/LT` check that sets `ZADD_OUT_NOP` and returns, and the unconditional `*newscore = score`.
- Restored `if (newscore) *newscore = score;` inside the `incr` block, and the old update condition
  `score != curscore && (!lt || score < curscore) && (!gt || score > curscore)` guarding the re-insert.

Effect: ZADD INCR with GT/LT that rejects the update no longer returns NOP, so the reply carries the
rejected (incremented) score instead of nil.

Failing oracle cases (4 of 315): "ZADD INCR LT/GT replies with nill if score not updated" and
"ZADD INCR LT/GT with inf", each for listpack and skiplist. They get a score instead of nil.
