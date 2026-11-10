# Re-introduced bug: FreeEnvironment() breaks JS in sibling Environments

**Bug.** `Environment::CleanupHandles()` disallows JS isolate-wide (`DisallowJavascriptExecutionScope`, THROW_ON_FAILURE)
and spins the shared loop until its handles close. Those loop turns also run timers/I/O callbacks of sibling
Environments on the same loop/isolate, and each fails with an "illegal access" exception thrown into unrelated code.
The fix re-allows JS in `InternalCallbackScope` while a cleanup is in progress.

**Hunks** (the release uses a `thread_local int handle_cleanup_depth` instead of `IsolateData::handle_cleanup_depth`, so a literal reversal doesn't apply; I removed the mechanism):
- `src/api/callback.cc`: removed `if (handle_cleanup_depth > 0) allow_js_.emplace(isolate);` (fix hunk in callback.cc). Sibling callbacks no longer re-allow JS.
- `src/env.cc`: removed the thread_local definition and the `handle_cleanup_depth++` / `OnScopeLeave` decrement in `CleanupHandles()` (fix hunk in env.cc, plus the counter declaration of the env.h hunk).
- `src/node_internals.h`: removed the `std::optional<AllowJavascriptExecutionScope> allow_js_` member and the extern counter declaration (node_internals.h hunk, plus counter declaration). The `<optional>` include is left in place (harmless).

**Failing test.** `EnvironmentTest.FreeEnvironmentWhileSiblingHasActiveHandles` (cctest): the process dies with
`<anonymous_script>:0 illegal access ... Node.js v26.13.0` when env2 is freed while env1's interval timer fires.
Observed on two runs. Build succeeded (make + cctest). I ran only this test (and a MultipleEnvironmentsPerIsolate check that produced the same output pre-crash); I did not run the full suite.
