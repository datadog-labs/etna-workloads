# buffer: prevent abort on indexOf with lone surrogate needle

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 37d12946dde82051a13a7353e899d2ba79f882ca applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: prevent abort on indexOf with lone surrogate needle

Signed-off-by: RafaelGSS <rafael.nunu@hotmail.com>
PR-URL: https://github.com/nodejs/node/pull/65430
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
