# Re-introduced bug: double TLS write ordering (fix 556b1ca9)

## Bug
When a TLSWrap is created on top of a user-provided socket that still has an active write, the new TLSWrap
writes TLS data to the underlying stream at once, and the old write's completion callback is delivered to the
new TLSWrap. That breaks the one-active-write rule: `Assertion !current_write_` fails in `TLSWrap::DoWrite`
(double TLS crash). It also leaves the previous owner's write callbacks unfired (stalled queued writes).

## Changes (src/crypto/crypto_tls.cc only)
1. `TLSWrap::EncOut()`: removed the early return on `has_active_write_issued_by_prev_listener`. This is the
   fix's `EncOut` hunk. Without it TLS data is sent before the earlier writes finish.
2. `TLSWrap::OnStreamAfterWrite()`: removed the block that forwards the finish notification to
   `previous_listener_`. This is the fix's `OnStreamAfterWrite` hunk. Without it the previous owner's write
   callback goes to the new TLSWrap.

The plumbing (JS arg, flag, `writesIssuedByPrevListenerDone`) is unchanged, so the tests'
`tls_wrap.wrap(..., false)` call signature still works and the build is fine.

## Results (run twice, stable)
- parallel/test-double-tls-client: FAIL, crash `Assertion failed: !current_write_` (crypto_tls.cc DoWrite), exit -6.
- parallel/test-double-tls-server: FAIL (same bug, crash/abort).
- parallel/test-socket-writes-before-passed-to-tls-socket: passes with this change.
- sequential/test-async-wrap-getasyncid: fails in this sandbox with `listen EPERM ... node-test.17.sock`
  (unix socket listen is blocked). This is environmental, not caused by the change. I did not run it on the clean tree to confirm.
