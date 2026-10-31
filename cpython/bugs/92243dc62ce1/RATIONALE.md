# Rationale

## Python/ceval.c, clear_gen_frame()
Reverses the fix's only implementation hunk: `frame->previous = NULL;` is moved
back to after `_PyFrame_ClearExceptCode(frame)` and `_PyErr_ClearExcState(...)`
(it was before them in the fixed code). v3.15.2 has the same fixed ordering
(plus an unrelated gh-143939 line after), so moving the line restores the
pre-fix ordering exactly. While the frame is cleared, `frame->previous` is
still set, so a frame object that outlives the generator takes ownership of a
copy of the frame with a dangling/live `previous`, creating the reference
cycle through `f_back`.

## Oracle failure
`FinalizationTest.test_exhausted_generator_frame_cycle` fails: after the
generator is exhausted, `frame.f_back` is not None. The other 50 cases pass.
