# stream: don't push null from closed promise #42694

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 538d8ce1069aa68cb546acc5bf31c1ca3a2fd39c applied to v26.13.0 (clean).

Upstream commit message:

```
stream: don't push null from closed promise #42694

closed promise is subscribed to first so will be
resolved first, before any read promise.

This causes data after EOF error to be thrown.

Remove the push null from the closed promise handler.
The push null gets done from the read handler
when it detects done.

PR-URL: https://github.com/nodejs/node/pull/45026
Fixes: https://github.com/nodejs/node/issues/42694
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
