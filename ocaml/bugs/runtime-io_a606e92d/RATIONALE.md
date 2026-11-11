# Rationale

## Bug re-introduced

File: `ocaml/runtime/io.c`, function `caml_ml_close_channel`.

The upstream fix (commit a606e92d8672, 2023-02-07, "Prevent `seek_in` from
marking buffer data as valid after closing the channel") addressed the
following hunk of `fix.diff`:

```
@@ -681,6 +681,9 @@ CAMLprim value caml_ml_close_channel(value vchannel)
      immediate caml_flush_partial or caml_refill, thus raising a Sys_error
      exception */
   channel->curr = channel->max = channel->end;
+  /* Prevent any seek backward that would mark the last bytes of the
+   * channel buffer as valid */
+  channel->offset = 0;
```

At the time of the original fix, `caml_ml_close_channel` unconditionally set
`channel->curr = channel->max = channel->end;` for *both* input and output
channels when closing. For input channels this is wrong: it makes the whole
(now-freed) buffer region `[buff, end)` appear "valid" to `caml_seek_in`,
which computes the acceptable backward-seek window as
`[channel->offset - (channel->max - channel->buff), channel->offset]`. A
backward `seek_in` after `close_in` could then land inside that bogus window
and set `channel->curr` to point into freed/uninitialized memory, so that a
subsequent `input_byte` would read garbage instead of raising `Sys_error`.
The original upstream fix for this report reset `channel->offset = 0` after
close so that the seek window could never again contain a valid-looking
backward target.

In today's tree (OCaml 5.5.2), the code around `caml_ml_close_channel` has
since been refactored: the `offset = 0` fix was superseded by a more direct
fix that makes the closed-channel buffer window empty for *input* channels
specifically (`channel->curr = channel->max = channel->buff;`, i.e. buffer
length 0), while keeping `channel->curr = channel->max = channel->end;` only
for the output-channel case. This is a different textual change from the
original patch but addresses exactly the same hunk/bug: it is what
"`channel->offset = 0`" was protecting against, re-expressed by removing the
backward-seek window entirely for input channels instead of resetting
`offset`.

### Hunk changed

I reverted this later, equivalent fix back to the original (pre-fix)
behaviour: both closed input and output channels now unconditionally get
`channel->curr = channel->max = channel->end;`, restoring the bogus
backward-seek window `[offset - (end - buff), offset]` for closed input
channels and therefore reintroducing the ability of `seek_in` after
`close_in` to make `input_byte` read freed/uninitialized buffer memory
instead of raising `Sys_error`.

Before (bug-fixed, today's tree):
```c
    if (channel->max == NULL){
      /* closed output channel: full buffer with max != NULL */
      channel->curr = channel->max = channel->end;
    }else{
      /* closed input channel: empty buffer */
      channel->curr = channel->max = channel->buff;
    }
```

After (bug reintroduced):
```c
    channel->curr = channel->max = channel->end;
```

This directly undoes the fix represented by the `fix.diff` hunk quoted
above (`CAMLprim value caml_ml_close_channel(value vchannel)`): the
`channel->offset = 0` safety measure from that hunk has no effect once the
input-channel buffer window is forced back to non-empty on close, since
`caml_seek_in`'s acceptance test becomes satisfiable again for backward
seeks after close.

## Build and test commands run

```
cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh
cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh
```

(The clean full rebuild was run in two `timeout 590 make -j8 ...` steps due
to sandbox command time limits; both completed with exit status 0 / normal
`make` completion messages, i.e. a full successful rebuild from a clean
tree.)

## Result

After the change, `ocaml/testsuite/tests/lib-channels/close_in.ml` (the only
test listed in `ORACLE.txt`) fails both in native and bytecode mode with:

```
Fatal error: exception Assert_failure("close_in.ml", 29, 4)
```

confirming that `input_byte` no longer raises `Sys_error` on the closed,
rewound channel, i.e. the original bug (#11878) has been reintroduced.

RESULT: injected
