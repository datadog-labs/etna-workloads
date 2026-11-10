# crypto: fix unhandled error in Hash._transform

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 656e57ebbfe562b23f36f835289c27ab4a069a62 applied to v26.13.0 (clean).

Upstream commit message:

```
crypto: fix unhandled error in Hash._transform

Signed-off-by: haramjeong <04harams77@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/63261
Fixes: https://github.com/nodejs/node/issues/63258
Reviewed-By: Tobias Nießen <tniessen@tnie.de>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
