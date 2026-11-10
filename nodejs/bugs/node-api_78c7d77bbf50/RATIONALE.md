# node-api: add napi_create_external_sharedarraybuffer

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 78c7d77bbf501ca03b94e3196c94ae8ca207bfcf applied to v26.13.0 (clean).

Upstream commit message:

```
node-api: add napi_create_external_sharedarraybuffer

Creates a SharedArrayBuffer from externally managed memory.

Fixes: https://github.com/nodejs/node/issues/62259
PR-URL: https://github.com/nodejs/node/pull/62623
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
Reviewed-By: Vladimir Morozov <vmorozov@microsoft.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
```
