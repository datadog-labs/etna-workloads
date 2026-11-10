# http2: omit server name when HTTP2 host is IP address

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fdad2fa66e77739583591f9991360a87532cb3c7 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: omit server name when HTTP2 host is IP address

Fixes: https://github.com/nodejs/node/issues/56189
PR-URL: https://github.com/nodejs/node/pull/56530
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Yongsheng Zhang <zyszys98@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
