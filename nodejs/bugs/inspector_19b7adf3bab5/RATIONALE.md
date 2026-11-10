# inspector: fix absolute URLs in network http

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 19b7adf3bab5dfe86f1a881599bae77c514da9a7 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
inspector: fix absolute URLs in network http

Some HTTP clients send an absolute URL in request.path. The network
inspection code always prefixed request.protocol and host,
which produced duplicated URLs such as
http://hosthttp://host/path in Network.requestWillBeSent and
Network.responseReceived.

Handle absolute URL paths directly and keep the existing
relative-path behavior unchanged.

Extend the HTTP inspector test to cover both GET and POST
requests that use an absolute URL as options.path and verify
that getResponseBody still returns the expected payload.

Signed-off-by: GrinZero <774933704@qq.com>
PR-URL: https://github.com/nodejs/node/pull/62955
Reviewed-By: Ryuhei Shima <shimaryuhei@gmail.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
```
