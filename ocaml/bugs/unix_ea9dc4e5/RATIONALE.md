# Rationale: re-introducing the bug fixed by ea9dc4e555 (GPR#1825, MPR#7238)

## What the fix did
It made `Unix.in_channel_of_descr` / `Unix.out_channel_of_descr` call new C stubs
(`unix_inchannel_of_filedescr` / `unix_outchannel_of_filedescr`). These stubs check that the
descriptor has stream semantics (fstat + SO_TYPE) before calling
`caml_ml_open_descriptor_in/out`. Before the fix, the externals pointed straight at
`caml_ml_open_descriptor_in/out`, so no check was done.

## Hunk changed

### ocaml/otherlibs/unix/unix_unix.ml (the Unix-side source of today's unix.ml)
The two externals now point at the runtime primitives again, with no check:

    external in_channel_of_descr : file_descr -> in_channel
                                 = "caml_ml_open_descriptor_in"
    external out_channel_of_descr : file_descr -> out_channel
                                  = "caml_ml_open_descriptor_out"

(before my edit they were `"caml_unix_inchannel_of_filedescr"` /
`"caml_unix_outchannel_of_filedescr"`). This reverses the fix hunk

    diff --git a/otherlibs/unix/unix.ml b/otherlibs/unix/unix.ml
    @@ -334,9 +334,9 @@ let single_write_substring fd buf ofs len =

which changed `"caml_ml_open_descriptor_in"` to `"unix_inchannel_of_filedescr"` (and the
same for out). Today the stubs carry a `caml_` prefix, and the Unix version of the module
lives in `unix_unix.ml`.

Changes I did not make:
- `otherlibs/unix/channels_unix.c` (the new file in the fix, `channels.c` at the time) is left
  in place. Nothing calls it any more. Deleting it would also mean editing the build files
  (the fix's Makefile hunk), and the rules forbid that.
- `channels_win32.c` (hunks `@@ -23,6 +23,42 @@`, `@@ -40,10 +76,13 @@`, `@@ -59,7 +98,10 @@`)
  is not changed. That code is Windows-only, is not compiled on this Linux build, and the
  Unix change alone brings the bug back.
- The Changes file and the testsuite are not touched.

## Effect
Datagram sockets and closed descriptors are accepted silently. The oracle test
tests/lib-unix/common/channel_of.ml now prints
"Datagram socket 1/2: FAILED (no error raised)" and "Closed file 1/2: FAILED (no error raised)".

## Commands run and results
1. `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
   - build OK; channel_of.ml => failed (bytecode and native output differ from the reference)
2. Final: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
   - build exit 0
   - `... testing 'channel_of.ml' => failed` (hasunix passed; bytecode failed; native failed)

RESULT: injected
