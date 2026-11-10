# src: fix off-thread cert loading in bundled cert mode

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 6432765a9c13929e5be8aab8e01f76924c9fe3fe applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix off-thread cert loading in bundled cert mode

https://redirect.github.com/nodejs/node/pull/59856 had an typo/mistake
in the skip conditions so that it is skipping when --use-openssl-ca
or --openssl-system-ca-path (configure time) are NOT used, even
though they should be skipped only when those ARE used (which is
not the default for default builds). This change fixes that so
that the perf numbers in that PR is true for the default build.

PR-URL: https://github.com/nodejs/node/pull/60764
Reviewed-By: Aditi Singh <aditisingh1400@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
```
