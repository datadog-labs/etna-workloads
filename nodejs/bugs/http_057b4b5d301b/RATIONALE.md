# http: fix keep-alive not timing out after post-request empty line

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 057b4b5d301bc26a6c011f2f32f15b54d335613c applied to v26.13.0 (clean).

Upstream commit message:

```
http: fix keep-alive not timing out after post-request empty line

Fixes: https://github.com/nodejs/node/issues/58140
PR-URL: https://github.com/nodejs/node/pull/58178
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
