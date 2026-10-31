# gh-118272 reintroduced

Fix hunk reversed: `Objects/genobject.c` `gen_close` fast path (added `_PyFrame_ClearLocals(...)` after setting the frame state).
In v3.15.2 that path calls `gen_clear_frame(gen)` (which reaches `_PyFrame_ClearLocals` via `_PyFrame_ClearExceptCode`).
I removed that call and only set `gi_frame_state = FRAME_CLEARED`, as the pre-fix code only set the state
(`FRAME_COMPLETED` no longer exists). The locals are no longer released on `close()`.
The `frame.c` / `pycore_frame.h` hunks (factoring out `_PyFrame_ClearLocals`) are a refactor; left as is.

Caveat: because the state is now CLEARED, `gen_dealloc` skips clearing, so locals leak for good rather than until dealloc.

Oracle: `GeneratorCloseTest.test_close_releases_frame_locals` fails (weakref stays alive).
The run also crashed/asserted (incomplete run), so many other test_generators cases are reported failing.
