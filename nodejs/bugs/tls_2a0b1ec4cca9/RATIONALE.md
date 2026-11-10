# tls: throw on invalid ALPNProtocols instead of aborting

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2a0b1ec4cca9740828b2b34cbc4497ac2ee0fc2f applied to v26.13.0 (clean).

Upstream commit message:

```
tls: throw on invalid ALPNProtocols instead of aborting

tls.connect() with malformed ALPNProtocols hit
CHECK_EQ(0, SSL_set_alpn_protos(...)) in the C++ layer and aborted
the process with SIGABRT.

Validate in JS instead, in convertALPNProtocols, so both client and
server fail early with a recoverable ERR_INVALID_ARG_VALUE:

- zero-length string protocols now throw from convertProtocols
- wire-format buffers are checked for zero-length and truncated
  entries
- an empty buffer or array is still accepted and means skip ALPN,
  matching the historical behavior for []

The C++ CHECK_EQ is left unchanged: once JS has validated the input,
a non-zero SSL_set_alpn_protos return is an internal invariant
failure rather than user-facing input.

Fixes: https://github.com/nodejs/node/issues/65069

Signed-off-by: Sankalp Thakur <sankalphimself@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65076
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
