# stream: prevent stream unexpected pause when highWaterMark set to 0

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 50695e5de14ccd8255537972181bbc9a1f44368e applied to v26.13.0 (clean).

Upstream commit message:

```
stream: prevent stream unexpected pause when highWaterMark set to 0

Co-authored-by: Robert Nagy <ronagy@icloud.com>
PR-URL: https://github.com/nodejs/node/pull/53261
Fixes: https://github.com/nodejs/node/issues/51930
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
