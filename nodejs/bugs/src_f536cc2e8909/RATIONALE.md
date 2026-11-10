# Re-introduced bug (fix f536cc2e8909)

**Bug:** `OnFatalError` assumed the calling thread had a current V8 isolate. `napi_fatal_error` (or the watchdog) can run on a thread with no isolate. The handler then dereferenced the null isolate, so the process segfaulted instead of aborting with SIGABRT.

**Hunk (src/node_errors.cc, `OnFatalError`):** The fix added `if (isolate == nullptr) { fflush(stderr); ABORT(); }` after `Isolate::GetCurrent()`. Today's code is different. It uses `Isolate::TryGetCurrent()` and passes the isolate to `TriggerNodeReport`. I restored the pre-fix shape:
- `TryGetCurrent()` becomes `GetCurrent()`.
- The handler now unconditionally calls `Environment::GetCurrent(isolate)`, which calls `isolate->InContext()`. That dereferences null on an isolate-less thread.
- The report call now uses that `env`, as the old code did.
- The null-isolate guard is absent.

**Failing test:** `node-api/test_fatal/test_threads` reports `not ok`. The failure is `assert(common.nodeProcessAborted(p.status, p.signal))`. The child crashes with SIGSEGV rather than aborting. `test` and `test2` still pass. I ran the tests twice and the failure was the same both times.
