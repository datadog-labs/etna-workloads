# Rationale

In v3.15.2 the fix's reader-side hunk (frozendict reserving its ref slot) is already present; the writer side is what I reverted, all in `Python/marshal.c`:

- `w_ref`: removed the "cannot marshal recursion %T objects" check and the `0x80000000` in-progress marker for code/slice/frozendict. Restored the old `int w` / `size_t s` computation. This reverses the `w_ref` hunks.
- Removed `w_complete()` and its calls in the frozendict, code and slice writers. This reverses the `w_complete` hunks.

Without the marker, a recursive code, slice or frozendict object is written as a TYPE_REF to an object that has not been finished. That data cannot be unmarshalled correctly.

Failing oracle cases (3): `test_reference_loop_code`, `test_reference_loop_slice` and `test_reference_loop_frozendict`. Each expects `ValueError` from `marshal.dumps` and gets none.
