Compiles an async generator with `async with (a as a0, a, ...)` for n managers.
Clean: the STOP_ITERATION block counts toward the limit, so n>=20 gives
"too many statically nested blocks" (CO_MAXBLOCKS=21). Buggy: the extra block is
not accounted for, so the limit/behavior differs (overflow/assert or wrong threshold).
