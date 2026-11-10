# lib: fix return type of setTimeout in net.Socket

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4439009d6531230f2f15992483d136bcc416c6ae applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix return type of setTimeout in net.Socket

Function setTimeout in net.Socket should return this,
not undefined, as doc said.

PR-URL: https://github.com/nodejs/node/pull/32722
Refs: https://nodejs.org/api/net.html#net_socket_settimeout_timeout_callback
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Zeyu Yang <himself65@outlook.com>
Reviewed-By: Gerhard Stöbich <deb2001-github@yahoo.de>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Yongsheng Zhang <zyszys98@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
