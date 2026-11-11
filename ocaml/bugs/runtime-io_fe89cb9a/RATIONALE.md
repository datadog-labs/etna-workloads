# Rationale
File: ocaml/runtime/io.c, caml_ml_flush. Restored the old body
`if (channel->fd != -1) caml_flush(channel);` in place of
`while (! flush_partial(channel, false)) continue;`.
Reverses hunk `@@ -825,8 +838,7 @@ CAMLprim value caml_ml_flush(value vchannel)`. A channel closed during a blocked flush (signal handler) now raises Sys_error EBADF.
(flush_partial helper left in place; still used by caml_flush_partial.)
Commands: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh
Result: lib-channels/close_during_flush.ml fails (Sys_error "Bad file descriptor").
