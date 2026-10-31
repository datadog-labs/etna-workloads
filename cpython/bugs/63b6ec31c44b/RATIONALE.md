# Rationale

Hunk reversed: `Lib/bdb.py`, `Bdb.dispatch_opcode` (the only implementation hunk of the fix; the doc/NEWS/test hunks are not code).

The fix made opcode events call `user_opcode()` unconditionally. I restored the pre-fix guard
`if self.stop_here(frame) or self.break_here(frame):` around `user_opcode(frame)`, `restart_events()` and the
`quitting` check, and removed the docstring paragraph the fix added. `restart_events()` is newer than the fix and
stays with the guarded body. The guard is the same code the fix removed.

Effect: an inline `set_trace()` on a `Pdb(skip=[...])` instance whose pattern matches the calling frame no longer stops there.

Oracle: 2 of 88 cases fail.
- `test.test_pdb.PdbTestInline.test_set_trace_with_skip` (the fix's test): "42" is never printed, because the inline breakpoint no longer stops.
- `test.test_pdb` (module-level doctests): `test_pdb_await_with_breakpoint` shows the same defect. `set_trace_async()` does not stop at the calling frame, so the output diverges.
