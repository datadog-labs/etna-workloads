# net: fix connect crash when call destroy in lookup handler

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 292016c91e7a13e76ee850be3240533ddb707aaf applied to v26.13.0 (fuzzy).

Upstream commit message:

```
net: fix connect crash when call destroy in lookup handler

PR-URL: https://github.com/nodejs/node/pull/51826
Fixes: https://github.com/nodejs/node/issues/50841
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Jiawen Geng <technicalcute@gmail.com>
```
