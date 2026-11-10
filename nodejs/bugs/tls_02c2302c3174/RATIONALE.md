# tls: propagate singleUse to the secure context

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 02c2302c317403eca825984f40db0ccd9ebb23de applied to v26.13.0 (clean).

Upstream commit message:

```
tls: propagate singleUse to the secure context

tls.connect() sets options.singleUse, and both TLSWrap.prototype.close()
and TLSSocket.prototype._destroySSL() check _secureContext.singleUse
before closing the context. Nothing ever assigned the flag to the
context, so the check never fired and each connection's SSL_CTX stayed
alive until the JS wrapper was garbage collected. The assignment was
lost when the context configuration was extracted into
configSecureContext().

Restore it in createSecureContext(), which owns the JS wrapper the flag
is read from, and make the close idempotent: a socket that swaps its
handle, as autoSelectFamily retries do, shares a single context between
the successive TLSWraps and each of them reaches the same teardown.

Signed-off-by: Carlos Vinicius <viniciusdev.26@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66025
Fixes: https://github.com/nodejs/node/issues/66002
Refs: https://github.com/nodejs/node/pull/38116
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
```
