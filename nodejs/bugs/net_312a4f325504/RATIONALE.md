# net: fix bufferSize

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 312a4f325504119df430eb3b1be5e0fa78f1c775 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
net: fix bufferSize

bufferSize should only look at writableLength otherwise it will
always show more than what is actually pending.

PR-URL: https://github.com/nodejs/node/pull/34088
Refs: https://github.com/nodejs/node/issues/34078
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
