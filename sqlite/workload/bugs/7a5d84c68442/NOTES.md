Contentless-delete FTS5 table with a corrupted %_docsize row (sz = X'02', too short for 3 columns).
DELETE of that row should fail with "database disk image is malformed" (fixed shell);
the buggy shell drops the error code from fts5StorageDecodeSizeArray and the DELETE silently succeeds.
