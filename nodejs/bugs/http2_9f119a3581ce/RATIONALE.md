# http2: make res.req a normal property

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9f119a3581ce5d68b0b1c587714d97361490d6fd applied to v26.13.0 (clean).

Upstream commit message:

```
http2: make res.req a normal property

The change in https://github.com/nodejs/node/pull/36505 broke
userland code that already wrote to res.req. This commit updates
the res.req property in the http2 compat layer to be a normal
property.

PR-URL: https://github.com/nodejs/node/pull/37706
Fixes: https://github.com/nodejs/node/issues/37705
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Darshan Sen <raisinten@gmail.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Mary Marchini <oss@mmarchini.me>
Reviewed-By: Gerhard Stöbich <deb2001-github@yahoo.de>
Reviewed-By: Michaël Zasso <targos@protonmail.com>
```
