# Rationale

Fix: `objectComputeSize` used `zmalloc_size(o)` instead of `sizeof(*o)` for the top-level object, so embedded keys were counted.

In 9.0.7 the per-type hunks were already folded into a single initializer, `size_t asize = zmalloc_size((void *)o);`, in src/object.c. I changed that one line back to `sizeof(*o)`. That reverses every per-type hunk (list, set, zset, hash, stream, int, raw) at once. The old code already used `zmalloc_size` for EMBSTR, so I added an explicit EMBSTR branch that sets `asize = zmalloc_size((void *)o)`. The INT and RAW cases now get `sizeof(*o)` plus the sds size, as before the fix.

Failing oracle case: `memoryusage of string`. For an int-encoded value under a 100000-byte key, MEMORY USAGE returns 16 where at least 100000 is expected.
