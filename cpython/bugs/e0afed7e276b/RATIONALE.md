# Rationale

The fix replaced the interpreter-wide `f_opcode_trace_set` flag with per-code local
INSTRUCTION events, enabled via `_PyEval_SetOpcodeTrace` whenever `f_trace_opcodes` / `f_trace`
are set or a trace event fires. In v3.15.2 the flag is gone, so the pre-fix behaviour is
re-created by removing the places where setting `f_trace_opcodes` after `sys.settrace` enables
opcode events (so the setting is not picked up unless it was set before tracing began).

Changes:
- `Objects/frameobject.c` `frame_trace_opcodes_set_impl`: no `_PyEval_SetOpcodeTrace(self, true)`
  when `f_trace_opcodes = True` is set (reverses the frameobject.c hunk 1 `if (f->f_trace)` call).
- `Objects/frameobject.c` `frame_trace_set_impl`: no `_PyEval_SetOpcodeTrace` after assigning `f_trace`
  (reverses frameobject.c hunk 2).
- `Python/legacy_tracing.c` `call_trace_func`: removed the `if (frame->f_trace_opcodes) _PyEval_SetOpcodeTrace(frame, true)`
  block (legacy_tracing.c hunk 2). This is a second path that would otherwise cover the case at
  the next trace event, so it must be reverted too.

Failing oracle cases: `TraceOpcodesTestCase.*` (63 failures, e.g. test_01_basic) fail with
"No 'opcode' events received by the tracer", and the added
`test_trace_opcodes_after_settrace` (opcode trace set after settrace) gets no opcode events.
