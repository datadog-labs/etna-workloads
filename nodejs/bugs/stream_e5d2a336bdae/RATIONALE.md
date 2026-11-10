# stream: destroy half-open sockets after iteration

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e5d2a336bdae6f6d728508bf8f27d04016986002 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: destroy half-open sockets after iteration

Async iteration left the writable side of `allowHalfOpen` duplexes open
after clean EOF. For `net.Socket` instances, this retained a live handle
after the peer disconnected.

Restore default iterator destruction. Callers that need to continue
writing can use `iterator({ destroyOnReturn: false })`.

Assisted-by: Codex
Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/65986
Fixes: https://github.com/nodejs/node/issues/65110
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
