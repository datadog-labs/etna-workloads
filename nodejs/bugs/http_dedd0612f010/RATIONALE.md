# http: enable call chaining with setHeader()

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit dedd0612f010d7654ff90b680bd43ce563faa270 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: enable call chaining with setHeader()

Make `response.setHeader` return the response object itself
so that multiple header setting can be chained.

Fixes: https://github.com/nodejs/node/issues/33148

PR-URL: https://github.com/nodejs/node/pull/35924
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Ricky Zhou <0x19951125@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
```
