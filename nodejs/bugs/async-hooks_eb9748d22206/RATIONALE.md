# Re-introduced bug: missing async_hooks destroy in AsyncWrap::AsyncReset

When an AsyncWrap (socket handle reused by http.Agent, HTTP parser from the freelist) is recycled via
`AsyncReset()`, an `init` has already been emitted for its old async_id. The old code assigned a new async_id
without emitting the matching `destroy`, so the old id was never destroyed (issue #19859).

## Change (src/async_wrap.cc only)
- Corresponds to the fix's `async_wrap.cc` AsyncReset hunk: removed the
  `if (async_id_ != kInvalidAsyncId) { EmitDestroy(); }` block (today's code has this in
  `AsyncReset(Local<Object>, double)`, and the constructor's `async_id_ = -1` is already expressed via kInvalidAsyncId).
  Recycled handles/parsers now overwrite async_id_ without a destroy.
- The other fix hunks (is_reused freelist symbol, parser.reinitialize flag, dedupe of parser init) were not
  reproduced: the release has since restructured them (parser.initialize always calls AsyncReset with a fresh
  resource), and the missing destroy is the core defect.

## Failing test
`parallel/test-async-hooks-http-agent-destroy` fails: the destroyed-ids set lacks the first request's socket
asyncId, so `assert.ok(destroyedIds.has(asyncIdAtFirstRequest))` throws.
