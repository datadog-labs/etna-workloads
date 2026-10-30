# Rationale

Fix hunk reversed: `zpopMinMaxCommand` in `src/t_zset.c` (the hunk that replaced
`getLongFromObjectOrReply` + `count <= 0 -> emptyarray` with
`getPositiveLongFromObjectOrReply`).

In 9.0.7 I restored the pre-fix argument parsing: the count is read with
`getLongFromObjectOrReply`, and `count <= 0` replies with an empty array *before*
the key lookup/type check. So `ZPOPMIN key 0` on a non-zset returns an empty array
instead of WRONGTYPE, and negative counts are accepted instead of erroring.
The `count == 0` check in `genericZpopCommand` is left in place; it becomes
unreachable from ZPOPMIN/ZPOPMAX, as before the fix. The `-1` sentinel is kept
because it is a naming convention for the plain pop. Using the old `0` sentinel
would have touched many more lines with no behavioural difference.

## Failing oracle cases (tests/unit/type/zset.tcl)
- `ZPOP/ZMPOP against wrong type`: `zpopmin foo 0` returns an empty array, not WRONGTYPE.
- `ZPOPMIN with negative count` / `ZPOPMAX with negative count`: `zpop zset -1` returns an empty array, not "ERR ... must be positive".
