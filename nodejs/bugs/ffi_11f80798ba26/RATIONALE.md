# ffi: throw on allocation failure in toArrayBuffer()

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 11f80798ba26e7fe482f58897de76e1a22c22d8f applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: throw on allocation failure in toArrayBuffer()

The copy path of toArrayBuffer() allocated its backing store with
V8's default failure mode, so a large length aborted the process
with a fatal out-of-memory error. toBuffer() throws a catchable
ERR_MEMORY_ALLOCATION_FAILED for the same input.

Allocate with kReturnNull and throw ERR_MEMORY_ALLOCATION_FAILED
when the allocation fails. The memory is left uninitialized because
memcpy() fills it right after.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66406
Fixes: https://github.com/nodejs/node/issues/66405
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
