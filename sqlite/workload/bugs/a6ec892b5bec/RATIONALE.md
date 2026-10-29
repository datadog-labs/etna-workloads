# Rationale

Fix: mem5 allocator misbehaves when the min request size is > 2^30 (memsys5Log loops forever).

## Changes
- `src/main.c` (SQLITE_CONFIG_HEAP): removed the clamp of `mnReq` to [1, 2^12]. Reverses the fix's main.c hunk.
- `src/mem5.c` `memsys5Log()`: removed the loop bound `iLog<(int)((sizeof(int)*8)-1)`. Reverses the fix's mem5.c loop hunk (today's bound is -1 rather than -2, same intent). The init-time comment/assert hunk is not behavioural and was left alone.

## Oracle
test/mem5.test: mem5-1.2 / 1.3 (min request 2^30, 2^30+1) now pass an unclamped mnReq to memsys5Log; the unbounded `(1<<iLog)<iValue` loop overflows and hangs or yields a wrong init result instead of SQLITE_NOMEM.

Result of ./check.sh: mem5-1.1 passes; mem5-1.2 hangs (infinite loop in memsys5Log), so 1.2–1.4 fail as an incomplete run (timeout).
