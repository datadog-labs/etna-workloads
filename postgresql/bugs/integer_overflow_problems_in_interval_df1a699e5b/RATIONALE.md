# Rationale

File: src/backend/utils/adt/timestamp.c; functions interval_cmp_value, interval_cmp_internal, interval_sign, interval_hash, interval_hash_extended.
Traces to the fix.patch timestamp.c hunks (INT128 linear representation, int128_compare, hashing via int128_to_int64).
Reverted to the pre-fix logic: interval_cmp_value computes an int64 span (time + month*30*USECS_PER_DAY + day*24*USECS_PER_HOUR), which can overflow. Comparison, sign and hashing use it, so extreme intervals compare wrongly.
(interval_sign and interval_hash_extended did not exist at fix time; adapted to the int64 span.)

Failing oracle case: src/test/regress||interval
