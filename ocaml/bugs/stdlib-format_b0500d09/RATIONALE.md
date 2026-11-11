# Rationale
File: ocaml/stdlib/format.ml. In `ksprintf` and `kasprintf` the buffer and formatter are created once at partial application (outside the continuation). The continuation flushes the queue and returns `Buffer.contents b` without resetting the buffer, instead of `flush_buffer_formatter b ppf`.
Reverses the fix hunks `@@ -1176,12 +1182,11 @@ let printf ...` (ksprintf) and `@@ -1194,7 +1199,7 @@ let asprintf` (flush_buf_formatter use).
The `flush_buf_formatter` hunk (`@@ -976,6 +976,12 @@`) is not reverted because today's equivalent `flush_buffer_formatter` is still used by other code.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Result: pr6824.ml fails.
