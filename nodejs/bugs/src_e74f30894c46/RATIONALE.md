# src: fix closing weak `HandleWrap`s on GC

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e74f30894c46c94aa1329e8462f811b8d5e54a91 applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix closing weak `HandleWrap`s on GC

In 0af62aae07ccbb3783030367ffe4, this was overlooked, with it
possibly leading to hard crashes.

Refs: https://github.com/nodejs/node/pull/29317

PR-URL: https://github.com/nodejs/node/pull/29640
Reviewed-By: Ben Coe <bencoe@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
```
