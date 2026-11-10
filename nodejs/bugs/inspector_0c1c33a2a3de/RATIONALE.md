# Rationale

Bug: `Debugger.setAsyncCallStackDepth` with depth 0 should disable the inspector async hooks, but the code called the *enable* function, so hooks stayed on.

Change (src/inspector_agent.cc, `Agent::SyncAsyncHookState`): the fix's hunk changed `DisableAsyncHook()` to use `inspector_disable_async_hooks()` instead of `inspector_enable_async_hooks()`. That function has since been refactored into a loop that selects enable/disable by `async_hook_wanted_`; the selection is replaced with always `inspector_enable_async_hooks()`, restoring the "disable calls enable" defect. Other fix hunks (getPromiseHooks, test) are test support only and not reproduced.

Failing test: parallel/test-inspector-async-call-stack:
`AssertionError: 4 !== 0: Setting maxDepth to 0 should disable async hooks`
