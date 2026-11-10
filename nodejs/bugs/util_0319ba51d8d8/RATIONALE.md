# util: fix debuglog.enabled not being present with callback logger

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0319ba51d8d8084e09bbb7f1b08c7480603b6976 applied to v26.13.0 (clean).

Upstream commit message:

```
util: fix debuglog.enabled not being present with callback logger

The method returned by the callback is missing the .enabled property.
This is added in a consistent way that it also verifies that it's a
getter.

Fixes: https://github.com/nodejs/node/issues/56676
PR-URL: https://github.com/nodejs/node/pull/59858
Reviewed-By: Michaël Zasso <targos@protonmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
