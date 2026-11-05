# Rationale

Both hunks are in src/backend/utils/adt/datetime.c. They trace to the datetime.c hunks of fix.patch, which added overflow-checked interval input helpers.

1. `int64_multiply_add()` — the fix introduced this helper to add val*multiplier to the microsecond total using `pg_mul_s64_overflow`/`pg_add_s64_overflow`. It now does an unchecked `*sum += val * multiplier` and always returns true. Hours, minutes, seconds, ms and us inputs that are out of range wrap silently instead of raising "interval out of range".
2. `AdjustDays()` — the fix added the range check on val and the `pg_mul_s32_overflow`/`pg_add_s32_overflow` checks. It now does an unchecked `tm_mday += (int) val * scale`. Out-of-range day and week inputs are truncated or wrapped.

Failing oracle case: src/test/regress||interval
