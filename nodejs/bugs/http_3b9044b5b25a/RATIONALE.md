# http: response should always emit 'close'

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 3b9044b5b25a572edff8269b59f29722044c1dda applied to v26.13.0 (clean).

Upstream commit message:

```
http: response should always emit 'close'

Fixes: https://github.com/nodejs/node/issues/40528

PR-URL: https://github.com/nodejs/node/pull/40543
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
