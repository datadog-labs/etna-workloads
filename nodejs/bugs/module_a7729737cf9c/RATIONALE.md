# module: fix crash when built-in module export a `default` key

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a7729737cf9c5e0c0ecf43bf55bd6f823d26fd61 applied to v26.13.0 (clean).

Upstream commit message:

```
module: fix crash when built-in module export a `default` key

PR-URL: https://github.com/nodejs/node/pull/51481
Fixes: https://github.com/nodejs/node/issues/51480
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
Reviewed-By: Guy Bedford <guybedford@gmail.com>
Reviewed-By: Geoffrey Booth <webadmin@geoffreybooth.com>
```
