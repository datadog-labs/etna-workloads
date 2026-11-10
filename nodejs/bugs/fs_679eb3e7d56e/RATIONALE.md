# Re-introduced bug: missing HandleScope in FileHandle close callback

**Bug.** In `FileHandle::ClosePromise()`, the libuv close callback creates a V8 handle (the `UVException` object) when `req->result < 0`, but runs outside any HandleScope. Closing an already-closed fd (EBADF) therefore aborts the process with `FATAL ERROR: v8::HandleScope::CreateHandle() Cannot create a handle without a HandleScope`.

**Hunk (src/node_file.cc).** Corresponds to the fix's single hunk, which added `HandleScope handle_scope(isolate);` inside the `if (req->result < 0)` branch. In today's code the lambda sits at a different place and has a different `UVException` call. I removed that same `HandleScope handle_scope(isolate);` line from the error branch, which restores the pre-fix behaviour.

**Failing test.** `parallel/test-filehandle-close` crashes (exit code -6) with `FATAL ERROR: v8::HandleScope::CreateHandle() Cannot create a handle without a HandleScope`. It failed on two runs.
