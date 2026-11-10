# http: revert #14024 writable is never set to false

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 8589c70c85411c2dd0e02c021d926b1954c74696 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: revert #14024 writable is never set to false

Setting writable = false in IncomingMessage.end made some errors
being swallowed in some very popular OSS libraries that we must
support. This commit add some of those use cases to the tests,
so we avoid further regressions.
We should reevaluate how to set writable = false in IncomingMessage
in a way that does not break the ecosystem.

See: https://github.com/nodejs/node/pull/14024
Fixes: https://github.com/nodejs/node/issues/15029
PR-URL: https://github.com/nodejs/node/pull/15404
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
```
