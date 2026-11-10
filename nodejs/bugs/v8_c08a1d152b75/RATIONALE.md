# v8: fix missing callback in heap utils destroy

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c08a1d152b758a1b97b81e9edce6ed60faaf4063 applied to v26.13.0 (clean).

Upstream commit message:

```
v8: fix missing callback in heap utils destroy

This fixes the v8.getHeapSnapshot() calls not properly being
destroyed. Pipeline calls would for example not properly end
without the callback being in place.

PR-URL: https://github.com/nodejs/node/pull/58846
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
Reviewed-By: Shelley Vohr <shelley.vohr@gmail.com>
```
