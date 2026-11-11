# Rationale
Hunk: ocaml/stdlib/format.ml, `kasprintf`. Replaces `k (flush_buffer_formatter b ppf)` with
`pp_flush_queue ppf ~end_with_newline:false; k (Buffer.contents b)`, so the shared buffer is no longer reset.
Reverses fix.diff hunk `@@ -1194,7 +1199,7 @@ let asprintf ...` (use of flush_buf_formatter in asprintf).
A partially applied `Format.asprintf "[%i]"` now accumulates output across calls (PR#6824).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
lib-format/pr6824.ml fails (native and bytecode).
