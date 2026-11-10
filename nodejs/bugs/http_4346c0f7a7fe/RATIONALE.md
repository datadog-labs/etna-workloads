# http: fix handling of HTTP upgrades with bodies

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4346c0f7a7fe67e4ed2d5c0bf7b5815957a8abf4 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: fix handling of HTTP upgrades with bodies

Previously, we ignored all indicators of the body (content-length or
transfer-encoding headers) and treated any information following
the headers as part of the upgraded stream. We now fully process the
requests bodies separately instead, allowing us to automatically handle
correct parsing of the body like any other HTTP request.

This is a breaking change if you are currently accepting HTTP Upgrade
requests with request bodies successfully, or if you use
socket-specific fields & methods on the upgraded stream argument.

In the former case, before now you will have received the request body
and then the upgraded data on the same stream without any distinction
or HTTP parsing applied. Now, you will need to separately read the
request body from the request (the 1st argument) and the upgraded
data from the upgrade stream (the 2nd argument). If you're not
interested in request bodies, you can continue to just read from the
upgrade stream directly.

In the latter case, if you want to access the raw socket, you should do
so via request.socket, instead of expecting the 2nd argument to be a
socket.

PR-URL: https://github.com/nodejs/node/pull/60016
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
```
