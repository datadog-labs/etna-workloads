# http: make ClientRequest#setTimeout() noop at end

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1b11824f514ac6fea77b7ae7b92e2ab64d970351 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: make ClientRequest#setTimeout() noop at end

Originally discovered and resolved by @szmarczak.

PR-URL: https://github.com/nodejs/node/pull/25536
Fixes: https://github.com/nodejs/node/issues/25499
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
