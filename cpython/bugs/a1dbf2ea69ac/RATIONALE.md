# Rationale

## Changed: `Objects/memoryobject.c`, `memory_clear()`

Reverses the fix's `memory_clear` hunk, which wrapped the release and
`Py_CLEAR(self->mbuf)` in `if (exports == 0)`. Before the fix, `tp_clear`
always dropped `self->mbuf`, even when buffers still referred to the
memoryview. The old `_memory_release()` failed with an ignored error when
`exports > 0`, so `memory_clear` still cleared `mbuf`.

Today's `_memory_release()` asserts `exports == 0`, so I kept the
`get_exports(self) == 0` guard around `_memory_release()` only. That is
equivalent to the old "release fails, error ignored" path. `Py_CLEAR(self->mbuf)`
is now unconditional again, as it was before the fix.

The other fix hunks (`_memory_release` becoming void, `memory_dealloc`) are
refactors that don't change behaviour here, so I left them alone.

## Oracle result

`./check.sh` reports 10 of 154 oracle cases failing, all in `OtherTest`. They
include `test_buffer_reference_loop` and `test_picklebuffer_reference_loop`,
the tests the fix added. The run is incomplete because the interpreter crashes
or asserts when the GC clears a memoryview that still has exported buffers.
The remaining `OtherTest` cases are listed as failing only because the run
died before reaching them.
