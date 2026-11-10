# lib: fix stack overflow check to not break on primitives

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 85496e94d3b7053f0954b15973c55bb1e8e1f11b applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix stack overflow check to not break on primitives

PR-URL: https://github.com/nodejs/node/pull/28338
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: Gireesh Punathil <gpunathi@in.ibm.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
