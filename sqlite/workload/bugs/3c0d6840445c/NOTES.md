`repro.sql` runs `SELECT decimal('999.999',3);` (test decimal-8000). Rounding an all-9s decimal expands it via `decimal_expand(p, nDigit+1, 0)` in the buggy build instead of keeping `nFrac`.
Clean shell prints `1000.000`. Buggy shell crashes (exit 139, nothing printed; the missing assert in `decimal_expand` removes the guard).
