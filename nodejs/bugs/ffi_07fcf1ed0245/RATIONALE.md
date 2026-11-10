# ffi: throw ERR_INVALID_ARG_TYPE for wrong-typed pointer and size

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 07fcf1ed0245ad2283ee4b16fd7a93c48862928d applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: throw ERR_INVALID_ARG_TYPE for wrong-typed pointer and size

GetValidatedPointerAddress() and GetValidatedSize() throw
ERR_INVALID_ARG_VALUE when the argument is not a bigint or not a
number. doc/api/errors.md reserves that code for a value of the right
type that is invalid or unsupported; a wrong type is
ERR_INVALID_ARG_TYPE. That is what the JavaScript validators behind
exportString() and exportBuffer() throw, and what the inline IsBigInt()
checks in toString(), toBuffer() and toArrayBuffer() throw for their
first argument. So ffi.exportBuffer(buf, ptr, 'x') reports a type error
while ffi.toBuffer(ptr, 'x') reports a value error for the same mistake.

Switch the two type-check branches to ERR_INVALID_ARG_TYPE. The branches
that reject a negative or non-integer value, or a value outside the
platform range, keep ERR_INVALID_ARG_VALUE and ERR_OUT_OF_RANGE.

This changes the code thrown for a non-bigint pointer by the getters,
the setters, exportBuffer(), exportArrayBuffer() and
exportArrayBufferView(), and for a non-number offset or length by the
getters, the setters, toBuffer() and toArrayBuffer(). The messages are
unchanged. No existing test asserted ERR_INVALID_ARG_VALUE on any of
these paths.

Refs: https://github.com/nodejs/node/pull/65500
Signed-off-by: Soul Lee <alus20x@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65842
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
```
