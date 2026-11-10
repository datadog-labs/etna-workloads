# readline: close dumb terminals on Control+D

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 93b341ed01a735f671c84e72a30e5e55945ea27f applied to v26.13.0 (fuzzy).

Upstream commit message:

```
readline: close dumb terminals on Control+D

This commit adds support for closing a readline interface
on Control+D when the terminal is dumb.

PR-URL: https://github.com/nodejs/node/pull/29149
Fixes: https://github.com/nodejs/node/issues/29111
Reviewed-By: Ben Noordhuis <info@bnoordhuis.nl>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
