# stream: fix fd is null when calling clearBuffer

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 639c36688352a872cd6bee1fcb55ce80f82aa68e applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix fd is null when calling clearBuffer

PR-URL: https://github.com/nodejs/node/pull/50994
Fixes: https://github.com/nodejs/node/issues/50979
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Raz Luvaton <rluvaton@gmail.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
```
