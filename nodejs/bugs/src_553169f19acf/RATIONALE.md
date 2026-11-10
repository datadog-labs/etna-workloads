# Re-introduced bug: abstract domain sockets broken in PipeWrap

**Bug.** Since libuv 1.46, `uv_pipe_bind`/`uv_pipe_connect` take the name as a C string (strlen-based), so an abstract socket name starting with `\0` is truncated to an empty name. Listening on or connecting to `'\0abstract'` therefore fails on Linux. The fix ported PipeWrap to `uv_pipe_bind2`/`uv_pipe_connect2`, which take an explicit length.

**Hunks** (the formatting-only hunks of the fix were not reproduced).
- `PipeWrap::Bind` (fix hunk `uv_pipe_bind` -> `uv_pipe_bind2(..., name.length(), 0)`): reversed to `uv_pipe_bind(&wrap->handle_, *name)`. The name is again treated as a NUL-terminated string, so a leading NUL gives an empty name.
- `PipeWrap::Connect` (fix hunk `uv_pipe_connect` -> `uv_pipe_connect2(..., name.length(), 0, ...)`): reversed to `Dispatch(uv_pipe_connect, &wrap->handle_, *name, AfterConnect)`. The current code also passes `UV_PIPE_NO_TRUNCATE`, which I removed along with the length. The Dispatch template supports the void-returning function.

**Failing test.** `parallel/test-pipe-abstract-socket-http` reports `not ok`. It was run twice with the same result. I did not capture the failure message text.
