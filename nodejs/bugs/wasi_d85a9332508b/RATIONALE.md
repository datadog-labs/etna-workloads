# Re-introduced bug: beforeExit emitted while a termination exception is pending

Bug: when a Worker running a WASI instance is terminated, EmitProcessBeforeExit called
into the runtime / asserted success (`ToLocalChecked`) on results that are empty once V8
has a pending termination exception, so the worker process aborted.

Hunks:
- src/api/hooks.cc (corresponds to the hooks.cc hunk of the fix): removed the
  `can_call_into_js()` early return and changed the ProcessEmit result handling back to
  `.ToLocalChecked()` instead of returning Nothing on an empty result. This restores the old
  "unchecked" behaviour (today's code computes exit code without JS, so the remaining failure point is ProcessEmit).
- src/node_process_events.cc (corresponds to the ProcessEmit hunk): the event-string
  creation result is again taken with `ToLocalChecked()` instead of propagating an empty MaybeLocal.

Failing test: wasi/test-wasi-worker-terminate — crashes (exit -6) with
`FATAL ERROR: v8::ToLocalChecked Empty MaybeLocal`.
