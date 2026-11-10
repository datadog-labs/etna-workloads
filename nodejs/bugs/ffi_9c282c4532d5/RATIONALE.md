# ffi: accept pointer BigInts in multi-argument fast calls

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9c282c4532d5df2750ffe4e30cceb97e6709d0b5 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
ffi: accept pointer BigInts in multi-argument fast calls

convertPointerArg ended with an unconditional getRawPointer call for
buffer and arraybuffer types, rejecting BigInt addresses that the
single-argument fast path and ToFFIArgument both accept. Drop the
fallback; hasPointerMemoryArg already converts memory-backed values,
and null, undefined, and strings are handled earlier.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5
PR-URL: https://github.com/nodejs/node/pull/64964
Fixes: https://github.com/nodejs/node/issues/64963
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```
