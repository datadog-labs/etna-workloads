# Rationale

Single hunk, `decimal_round()` in `ext/misc/decimal.c`, reversing the fix's only implementation hunk.

- Removed the "all leading digits are 9" block (the loop plus `decimal_expand(p, p->nDigit+1, ...)`) and the `assert( p->a[0]<=9 )`. In 3.54.1 that call passes `p->nFrac`, whereas the fix passes `0`, so the hunk could not be reversed literally.
- Restored the pre-fix overflow handling: when `a[0]>9` after carry, set `a[0]=1` and do `nFrac--`. With no fractional digits this adjusts nothing useful. The carry out of an all-9 prefix is lost, so the result is wrong.
- Restored `p->a[N]>4` in place of `>=5`. They are equivalent for digits 0-9.

Failing oracle cases: decimal-7000, 7010 and 7020. For example, `decimal('999999999999999', 1)` no longer returns `1000000000000000`. The other new cases (7030-7080) pass, as they did before the fix.
