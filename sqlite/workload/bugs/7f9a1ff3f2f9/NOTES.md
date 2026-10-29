# Reproducer notes

`repro.sql` runs a single query (upstream test `jsonb01-2.0`):

    SELECT x'8ce6ffffffff171333' -> '$';

The literal is a corrupt JSONB blob. It encodes a node whose declared
payload size, when added to the current offset, is meant to overflow the
end-of-blob bounds check performed in `jsonbPayloadSize()`.

- `sqlite3-clean` (fix applied): the bounds-check arithmetic is done in
  64-bit (`(i64)i+sz+n`), so the oversized size is correctly detected as
  out of range, and the query reports `Error: malformed JSON` (exit 1).

- `sqlite3-buggy` (`injection.patch` applied, reverting the fix): the same
  arithmetic is done in 32-bit (`i+sz+n`, all `u32`), so `i+sz+n` wraps
  around and the bounds check passes incorrectly. This lets the JSON
  renderer walk past the end of the (very short) 9-byte blob buffer,
  reading out of bounds. The process crashes (exit status -11, SIGSEGV)
  instead of returning a parse error.
