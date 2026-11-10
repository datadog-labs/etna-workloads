# buffer: prevent string write offset overflow

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 13e7d54f6736879073015e325509d47553d73713 applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: prevent string write offset overflow

Reject offsets outside the destination buffer before subtracting from
its length in SlowWriteString. Normalize wrapper arguments once so
validated values reach the native binding.

Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/65043
Reviewed-By: Robert Nagy <ronagy@icloud.com>
```
