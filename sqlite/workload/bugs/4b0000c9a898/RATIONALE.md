# Rationale

All changes are in `tree/ext/fts3/fts3.c`. The fix's hunks still apply to the code, so each one is undone in place.

1. `fts3DoclistPhraseMerge()`: the `bDescDoclist` branch that allocated a fresh `aOut` buffer is removed. Output is written over the right-hand doclist again (`aOut = aRight`). The `sqlite3_free(aRight); *paRight = aOut;` block is removed too. This reverses the fix's malloc and swap hunks. The signature and the `rc` plumbing stay as they are. They are harmless once the function can no longer fail.
   With order=DESC, a merged doclist can encode larger than the right-hand input. For example, (1,-1) is smaller than (-1) as stored. The in-place output then overruns or truncates the buffer.
2. `fts3TermSelectMerge()`: the first-term buffer is allocated as `nDoclist` bytes again. The fix's `+ FTS3_VARINT_MAX + 1` padding is removed. The later `memset` of the padding is removed too, since it would write past the allocation.

## Oracle results
`fts3prefix-7.1` fails: `"a* b"` on the order=DESC table returns `[]` instead of `-1`. Test 7.0 and the rest pass. 7.1 is the case the fix added for this bug.
