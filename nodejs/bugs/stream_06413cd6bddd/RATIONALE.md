# stream: fix Utf8Stream stall after full write of multi-byte data

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 06413cd6bdddc3aa2c0b7dfed13a8aa07b248b60 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix Utf8Stream stall after full write of multi-byte data

Signed-off-by: Daijiro Wachi <daijiro.wachi@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/63964
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
