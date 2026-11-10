# http: remove 'data' and 'end' listener if client parser error

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 140b25a35f40a19d281865b396dd3a527f7be4e9 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: remove 'data' and 'end' listener if client parser error

There might be the case of some more data coming through after
the parser has returned an error and we have destroyed the socket.
We should also be removing the 'data' event handler.

Fixes: https://github.com/nodejs/node/issues/40242

PR-URL: https://github.com/nodejs/node/pull/40244
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
