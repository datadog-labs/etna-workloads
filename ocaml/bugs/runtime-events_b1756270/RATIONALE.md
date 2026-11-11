# Rationale
Hunk: ocaml/otherlibs/runtime_events/runtime_events_consumer.c, in caml_runtime_events_create_cursor.
Removed the `if (cursor->metadata.max_domains > Max_domains_max) { ret = E_CORRUPT_STREAM; goto fail_metadata_corrupt; }` check
before allocating `current_positions`. This reverses fix.diff hunk
`@@ -229,6 +229,13 @@ caml_runtime_events_create_cursor(...)` (adapted to today's goto-based error path).
The test tests/lib-runtime-events/test_corrupted.ml is part of the fix and is already present.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: test_corrupted fails (segfault, exit code -11, in the run action).
