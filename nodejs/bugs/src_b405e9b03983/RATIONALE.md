# src: fix out-of-bounds write when transcoding odd-length ucs2

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit b405e9b0398383e0ba6cbb76ca6a15288bfaf40d applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix out-of-bounds write when transcoding odd-length ucs2

Signed-off-by: Nashit-h <nashit@bugqore.com>
PR-URL: https://github.com/nodejs/node/pull/64512
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
```
