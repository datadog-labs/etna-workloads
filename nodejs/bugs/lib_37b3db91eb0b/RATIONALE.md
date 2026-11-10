# lib: fix stream loading bug in node:bench

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 37b3db91eb0bc724a519ff1700f5a27117076553 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix stream loading bug in node:bench

Not all of the stream APIs are correctly loaded until
the `node:stream` module is loaded.

Signed-off-by: James M Snell <jasnell@gmail.com>
Assisted-by: Opencode
PR-URL: https://github.com/nodejs/node/pull/66114
Fixes: https://github.com/nodejs/node/issues/41641
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
