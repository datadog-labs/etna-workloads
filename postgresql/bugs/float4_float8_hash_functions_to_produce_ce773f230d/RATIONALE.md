# Rationale

File: src/backend/access/hash/hashfunc.c, functions hashfloat4, hashfloat4extended, hashfloat8, hashfloat8extended.

Each function had a NaN canonicalization step (`if (isnan(key)) key = get_floatN_nan();`). In today's code the float4 variants test the widened float8 value (`key8`). I removed all four steps. They trace to the four hunks of fix_impl.patch that add them, one per function. The `#include "utils/float.h"` hunk is left alone because it is harmless.

Without the steps, NaNs with different bit patterns hash differently even though they compare equal. That is the original bug.

Failing oracle case: src/test/regress||hash_func
