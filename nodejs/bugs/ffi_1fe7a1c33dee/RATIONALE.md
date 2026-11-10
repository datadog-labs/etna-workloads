# ffi: validate the value passed to the float setters

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1fe7a1c33dee46943e985a052425a8422164513a applied to v26.13.0 (fuzzy).

Upstream commit message:

```
ffi: validate the value passed to the float setters

setInt8() through setUint64() require IsNumber() before any range check
and reject anything else with ERR_INVALID_ARG_VALUE, but setFloat32()
and setFloat64() call ToNumber() and write whatever it returns, so a
string, a boolean or a plain object is converted instead of rejected
and a typo such as '1,5' stores NaN in native memory with no error at
the call site. The same double is type-checked when it is passed as a
call argument: ToFFIArgument() requires IsNumber() and otherwise throws
"Argument %s must be a double".

The coercion also discards a pending exception. When ToNumber() fails
because the value has a valueOf() that throws, the branch throws
ERR_INVALID_ARG_VALUE on top of the exception V8 has already scheduled,
so the original error never reaches the caller, whereas
DataView.prototype.setFloat64() and Buffer.prototype.writeDoubleLE()
both propagate it.

Check IsNumber() instead, matching the wording of the integer setters
and of ToFFIArgument(). The check runs before any conversion, so
valueOf() is never invoked and there is no pending exception left to
discard. This was the only ToNumber(context) call in src/.

Signed-off-by: Soul Lee <alus20x@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65342
Fixes: https://github.com/nodejs/node/issues/65341
Refs: https://github.com/nodejs/node/pull/62858
Refs: https://github.com/nodejs/node/pull/64614
Refs: https://github.com/nodejs/node/pull/64691
Refs: https://github.com/nodejs/node/pull/65032
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Juan José Arboleda <soyjuanarbol@gmail.com>
```
