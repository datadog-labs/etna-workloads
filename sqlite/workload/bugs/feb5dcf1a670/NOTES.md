Reproducer (repro.sql): disables defensive mode (shadow tables are normally
protected from direct writes), then builds an FTS4 table and corrupts its
shadow tables: sets %_docsize.size to a truncated single-byte varint (x'88',
a continuation byte with no following byte) for one row, and separately sets
%_stat.value (the global doctotal/token-count record) to an empty blob.
matchinfo(t1, 'l') and matchinfo(t1, 'a') are then run, which parse these
blobs with FTS3's internal varint reader.

Clean shell (with the fix): the varint reader is bounds-checked against the
end of the blob, so both corrupted records are detected and matchinfo
reports "database disk image is malformed".

Buggy shell (injection.patch applied, bounds check removed): the varint
reader walks past the end of the (possibly empty/zero-length) blob into
adjacent heap memory with no bounds check. For the empty %_stat blob this
reads uninitialized/out-of-bounds memory and crashes with SIGSEGV instead of
reporting corruption (exit status differs: 1 on clean vs -11 on buggy).
