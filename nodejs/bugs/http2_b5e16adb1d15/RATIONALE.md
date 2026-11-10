# http2: send RST code 8 on AbortController signal

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b5e16adb1d155759e7db405eead5a43cd425785d applied to v26.13.0 (clean).

Upstream commit message:

```
http2: send RST code 8 on AbortController signal

Fixes: https://github.com/nodejs/node/issues/47321
Refs: https://www.rfc-editor.org/rfc/rfc7540#section-7
PR-URL: https://github.com/nodejs/node/pull/48573
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
```
