# Reproducer notes

`repro.sql` runs:

    SELECT quote(substr(x'313233343536373839',0x7ffffffffffffffe,5));

This is the exact case added as `func-2.13` by the fix commit.

The blob is 9 bytes long (len=9), p1=0x7ffffffffffffffe (huge, >= len),
p2=5.

- **Clean shell** (fixed `substrFunc`): checks `p1>=len` first and clamps
  `p1 = p2 = 0`, so the result is an empty blob, printed as `X''`, exit 0.
- **Buggy shell** (`injection.patch` applied, reverting to the older logic):
  computes `p1+p2>len`, taking the `p2 = len-p1` branch. Since `p1` is huge,
  `len-p1` is a huge negative number recast to a huge size when passed as
  `u64` to `sqlite3_result_blob64`, causing an out-of-bounds read/crash
  (the old `assert(p2>0)` is also removed/weakened in the injected version,
  so in a non-assert build it would just read out of bounds instead of
  asserting). The buggy shell crashes with SIGSEGV (exit status -11),
  while the clean shell returns `X''` with exit status 0.
