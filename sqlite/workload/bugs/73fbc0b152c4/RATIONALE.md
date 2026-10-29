# Rationale

Single hunk, src/vdbe.c, OP_SeekRowid. It reverses the fix's only implementation hunk.

- `i64 iKey` goes back to `u64 iKey`.
- The explicit MEM_Str / MEM_Int / MEM_Real range-checked conversion goes back to the
  old `applyAffinity(&x, SQLITE_AFF_NUMERIC, encoding); if(!(x.flags&MEM_Int)) goto jump_to_p2; iKey = x.u.i;`.
  The 3.54.1 code was a refined variant of the fix's code (its upper bound was
  9223372036854774784.0), so the fix hunk could not be reversed textually. The
  pre-fix text is restored directly.

With this code, a REAL key at the 64-bit boundaries, such as -9223372036854775808.0 or
9223372036854775808.0, is not found by rowid lookup.

Oracle cases that fail (test/intpkey.test): intpkey-18.2, intpkey-18.3 and intpkey-19.0.
