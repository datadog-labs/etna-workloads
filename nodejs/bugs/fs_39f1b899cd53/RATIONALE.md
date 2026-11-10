# fs: fix edge case in readFileSync utf8 fast path

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 39f1b899cd536de4d4c9bbf56f24927d8d06999a applied to v26.13.0 (clean).

Upstream commit message:

```
fs: fix edge case in readFileSync utf8 fast path

Fix a file permissions regression when `fs.readFileSync()` is called in
append mode on a file that does not already exist introduced by the
fast path for utf8 encoding.

PR-URL: https://github.com/nodejs/node/pull/52101
Fixes: https://github.com/nodejs/node/issues/52079
Refs: https://github.com/nodejs/node/pull/49691
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Vinícius Lourenço Claro Cardoso <contact@viniciusl.com.br>
Reviewed-By: Yagiz Nizipli <yagiz.nizipli@sentry.io>
```
