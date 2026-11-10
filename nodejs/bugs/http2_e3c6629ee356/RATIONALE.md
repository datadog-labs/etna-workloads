# http2: emit session close before stream close

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e3c6629ee3562a5812bcd657c89432f6cd4bbb73 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: emit session close before stream close

Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/63414
Fixes: https://github.com/nodejs/node/issues/63412
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Stephen Belanger <admin@stephenbelanger.com>
```
