# http2: always call callback on Http2ServerResponse#end

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fdcd4893ff91f359433fb7526d4e3133260de777 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: always call callback on Http2ServerResponse#end

Fixes: https://github.com/nodejs/node/issues/28001

PR-URL: https://github.com/nodejs/node/pull/33911
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Denys Otrishko <shishugi@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
