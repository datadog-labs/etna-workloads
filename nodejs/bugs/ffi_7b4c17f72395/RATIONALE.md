# ffi: throw on missing memory helper arguments

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 7b4c17f72395d3c41aaae2274bbb23d6de65d073 applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: throw on missing memory helper arguments

ffi.getInt8() through ffi.getFloat64(), ffi.setInt8() through
ffi.setFloat64(), ffi.toBuffer() and ffi.toArrayBuffer() return
undefined instead of throwing when a required argument is omitted, so a
call that read or wrote nothing cannot be told apart from one that read
a zero byte. All 22 helpers behave this way.

GetValidatedPointerAddress() and GetValidatedSize() already reject the
same argument when it is passed explicitly as undefined. The
args.Length() test in front of them short-circuits the call and returns
Nothing without scheduling an exception. These six are the only tests in
src/ where args.Length() can skip a call that throws; the only other
Length() tests that guard a call at all guard Buffer::HasInstance(),
which cannot throw. The remaining tests in this file guard an inline
predicate and throw in the branch, which is why setUint8(ptr) reports
"Expected an offset argument" while setUint8() reports nothing at all.

Drop those tests. FunctionCallbackInfo::operator[] returns Undefined for
an out-of-range index, which is exactly the value these validators
reject, so each missing argument now produces the error its explicit
undefined counterpart produces. The documentation already describes this
behavior: the signatures are ffi.getInt8(pointer[, offset]),
ffi.setInt8(pointer, offset, value) and
ffi.toBuffer(pointer, length[, copy]), and the getters are documented to
return a number or a bigint.

ExportBytes() carried the same two tests. They are unreachable through
the public API because exportBytes is not exported and its three callers
all validate len in JavaScript first, but they are the same shape.

Signed-off-by: Soul Lee <alus20x@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65500
Fixes: https://github.com/nodejs/node/issues/65499
Refs: https://github.com/nodejs/node/pull/62072
Refs: https://github.com/nodejs/node/pull/62858
Refs: https://github.com/nodejs/node/pull/65842
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
