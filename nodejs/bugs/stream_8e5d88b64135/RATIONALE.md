# stream: pipeline wait for close before calling the callback

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 8e5d88b6413558b6b4bc127f87fc8122311639ae applied to v26.13.0 (fuzzy).

Upstream commit message:

```
stream: pipeline wait for close before calling the callback

The pipeline should wait for close event to finish before calling
the callback.

The `finishCount` should not below 0 when calling finish function.

Fixes: https://github.com/nodejs/node/issues/51540

Co-authored-by: wh0 <wh0@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/53462
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
```
