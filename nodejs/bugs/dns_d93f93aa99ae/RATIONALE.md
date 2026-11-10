# Bug
In QueryAnyWrap (src/cares_wrap.cc), AAAA TTLs were read from `addr6ttls[i]` where `i` indexes the combined results array (A + AAAA), instead of the AAAA-local offset `i - a_count`. With A records present, the wrong TTLs (or out-of-bounds/uninitialized data) are reported for AAAA entries in `resolveAny()`.

# Changes
1. `addr6ttls[i - a_count].ttl` -> `addr6ttls[i].ttl` (fix hunk 2: the offset correction).
2. Removed `CHECK_EQ(ret->Length(), a_count + aaaa_count);` (fix hunk 1: the added sanity check).

# Failing test
parallel/test-dns-resolveany: not ok, AssertionError: Expected values to be strictly deep-equal (AAAA ttl differs from the expected value).
