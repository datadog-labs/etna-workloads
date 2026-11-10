# ffi: validate pointer ranges in optimized calls

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fa7efaf782991720e6aece741704076a8e4f1f6d applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: validate pointer ranges in optimized calls

On x64 SysV and arm64, a Fast API signature with two or more
arguments that uses only pointer and float types got no JS wrapper.
V8 then truncated pointer BigInts silently. With `-1n` or
`2n ** 64n + 5n`, cold calls threw ERR_INVALID_ARG_VALUE, while
optimized calls passed 0xffffffffffffffff or 5 to native code.

Use the argument wrapper for any signature with a pointer argument.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66371
Fixes: https://github.com/nodejs/node/issues/66370
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
