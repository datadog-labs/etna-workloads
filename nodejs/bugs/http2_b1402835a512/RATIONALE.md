# http2: skip writeHead if stream is closed

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b1402835a512f14fa9f8dd23d3e0cee8cfe888a2 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: skip writeHead if stream is closed

Fixes: https://github.com/nodejs/node/issues/57416
PR-URL: https://github.com/nodejs/node/pull/57686
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Jake Yuesong Li <jake.yuesong@gmail.com>
```
