# Rationale

Changed `src/cmd/compile/internal/escape/call.go` (`callCommon`) only.

The fix split `OUNSAFESTRINGDATA`/`OUNSAFESLICEDATA` out of the
`OLEN, OCAP, OREAL, OIMAG, OCLOSE` case, where the argument went to a discard
hole, into their own case that flows the argument to `ks[0]`. I reversed this:
the two ops are back in the discard case and the separate case is removed. The
code is otherwise identical to the pre-fix form (go1.27.3 uses `e.discard(call.X)`
instead of `argument(e.discardHole(), ...)`, which is equivalent).

Effect: `unsafe.SliceData(s)` and `unsafe.StringData(s)` no longer propagate
the argument's flow to the result. The pointee can be stack allocated or
freed while the returned pointer is still live.

Oracle: `test/fixedbugs/issue57823.go` fails. The run crashes with a runtime
fatal error (memory corruption), as the issue describes.
