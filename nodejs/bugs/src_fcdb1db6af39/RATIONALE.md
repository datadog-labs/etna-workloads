# Re-introduced bug: missing HandleScope in StreamReq::Done()

**Bug:** `StreamReq::Done()` creates handles (`async_wrap->object()`, `env->error_string()`, `OneByteString(...)`) when `error_str != nullptr`, without its own `v8::HandleScope`. When it is called from a libuv callback with no enclosing scope (e.g. an unref'd TLS socket whose request completes with an error), V8 aborts on handle creation without a scope.

**Hunk:** `src/stream_base.cc`, `StreamReq::Done()`. The fix's hunk in `src/stream_base-inl.h` added `v8::HandleScope handle_scope(env->isolate());` inside `if (error_str != nullptr)`. The function has since moved to `src/stream_base.cc`. I removed that same line, which restores the old behaviour.

**Failing test:** `parallel/test-https-agent-unref-socket`. The child process aborts with a native stack trace, and the parent assertion reports `AssertionError: Expected values to be strictly equal: null !== 0`. It failed in both runs.
