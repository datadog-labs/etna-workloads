# Re-introduced bug: async call stack depth change after worker is done (nodejs/node#28528)

**Bug.** When a worker has finished and is only waiting for inspector sessions to disconnect
(`waiting_for_sessions_disconnect_`), a protocol client can still call
`Debugger.setAsyncCallStackDepth`. V8 then calls `maxAsyncCallStackDepthChanged()`, which tries
to toggle the inspector async hook by calling into JS on an isolate that is mostly torn down.
The result is a crash (abort).

**Changes (both in src/inspector_agent.cc).**
1. `NodeInspectorClient::maxAsyncCallStackDepthChanged`: removed the
   `if (waiting_for_sessions_disconnect_) return;` early exit. This is the direct reversal of the
   fix's only hunk.
2. `Agent::SyncAsyncHookState`: removed the later-added `if (!parent_env_->can_call_into_js()) return;`
   guard. Today's code has this second guard, which covers the same "worker is done" situation, so
   reverting hunk 1 alone left the test passing. Removing it restores the old behaviour, where the
   toggle JS runs after the worker is done. This hunk is part of the same fix re-expressed for
   current code.

**Failing test.** `parallel/test-inspector-async-hook-after-done` crashes (exitcode -6), stable over two runs:
`Assertion failed: "Unreachable code reached": "Cannot toggle Inspector's AsyncHook, please report this."`
at `SyncAsyncHookState()` ("illegal access"), reached from `maxAsyncCallStackDepthChanged`.
