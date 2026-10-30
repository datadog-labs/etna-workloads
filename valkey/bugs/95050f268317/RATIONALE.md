# Rationale

## Changes (src/rdb.c, rdbLoadObject, stream loading)
1. Removed the check `if (s->length && !raxSize(s->rax)) { rdbReportCorruptRDB("Stream length inconsistent with rax entries"); ... }`
   — this is exactly the hunk added by fix.patch (it is present verbatim in 9.0.7).
2. Removed the later check `if (s->length != valid_entries) {...}` ("Stream length inconsistent with the
   number of valid entries"). This is a second path covering the same defect: a stream whose length is
   non-zero while the rax holds no live entries (valid_entries == 0 for an empty rax). Without it, reversing
   only hunk 1 does not bring the bug back. Both guard against the same corrupt metadata, which later
   panics in streamLastValidID.

## Oracle failures
- `fuzzer findings - streamLastValidID panic`: restore returns OK instead of "Bad data format".
- `stream length inconsistent with valid entries`: also fails, since check 2 was removed (same defect family).
