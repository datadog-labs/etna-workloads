# ffi: fix exportArrayBuffer type check

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c1073f31ded6b902bf102641f4b3220cff56091c applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: fix exportArrayBuffer type check

Use isArrayBuffer() instead of comparing Object.prototype.toString()
output. The old check depended on Symbol.toStringTag, so a real
ArrayBuffer with a custom tag was rejected, and a plain object tagged
'ArrayBuffer' passed and failed later in native code with a misleading
error.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66455
Fixes: https://github.com/nodejs/node/issues/66454
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
