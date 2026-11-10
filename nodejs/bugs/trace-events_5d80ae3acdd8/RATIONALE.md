# Re-introduced bug: tracing modifications allowed from worker threads

Bug: `require('trace_events')` succeeded inside Worker threads, and (in the inspector) `NodeTracing.start` was
no longer refused for worker-thread sessions, so workers could modify global tracing state owned by the main thread.

Hunks:
1. `lib/trace_events.js` (fix hunk: `|| !isMainThread` guard). In today's code the guard is `ownsProcessState`;
   I removed it from the `throw ERR_TRACE_EVENTS_UNAVAILABLE` condition, so workers can load the module again.
2. `src/inspector/tracing_agent.cc` (fix hunk: `!env_->is_main_thread()` error in `TracingAgent::start`; today
   `owns_process_state()`). Removed that check so worker sessions may start tracing.
Not changed: the `UpdateTraceCategoryState` early return in `src/env.cc` (kept; removing it risks unsafe crashes and is not needed for the failure).

Results: `parallel/test-trace-events-api-worker-disabled` FAILS (worker no longer emits ERR_TRACE_EVENTS_UNAVAILABLE,
so `common.expectsError` is never called -> "not ok"), stable over two runs.
`parallel/test-trace-events-dynamic-enable-workers-disabled` still passes (the inspector refusal evidently
remains via another path in today's code, e.g. the worker inspector lacking a tracing agent).
