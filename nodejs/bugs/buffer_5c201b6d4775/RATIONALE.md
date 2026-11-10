# buffer: fix writeUInt16BE range check

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5c201b6d477525a080b11d1bd49a7c94fe81f8ac applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: fix writeUInt16BE range check

Fixes: https://github.com/nodejs/node/issues/24205

PR-URL: https://github.com/nodejs/node/pull/24208
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
