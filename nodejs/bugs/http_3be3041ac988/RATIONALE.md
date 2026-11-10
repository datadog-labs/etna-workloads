# http: fix perf_hooks detail.req.url port and proxied path

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 3be3041ac988cb99367623f84798de23b99a2982 applied to v26.13.0 (clean).

Upstream commit message:

```
http: fix perf_hooks detail.req.url port and proxied path

The perf_hooks HTTP client entry built the reported URL from the bare
hostname, dropping non-default ports and IPv6 brackets, and appended
the request path even after it had been rewritten to absolute-form for
proxying, duplicating the protocol and authority.

Report the connection authority captured at request creation and, for
proxied requests, use the rewritten absolute-form target as-is.

Fixes: https://github.com/nodejs/node/issues/59625
Signed-off-by: Stefano Baghino <stefano@baghino.me>
PR-URL: https://github.com/nodejs/node/pull/64311
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: theanarkh <theratliter@gmail.com>
```
