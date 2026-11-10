# http: fix leaked error listener on sync HTTP req create + destroy

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e0b79633f64ea9dff2a0e74ae131a7cb8484e591 applied to v26.13.0 (clean).

Upstream commit message:

```
http: fix leaked error listener on sync HTTP req create + destroy

Previously, this resulted in an error listener being added but not
cleaned up when the socket was freed back to the agent pool.

This also updates the docs to clarify when req.destroy() kills the
underlying socket - only if it's called during request processing (more
specifically: after onSocketNT, at which point we may have started
reading & writing).

Signed-off-by: Tim Perry <pimterry@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/62872
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
```
