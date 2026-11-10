# ffi: fix crash in refCallback and unrefCallback

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 428e9bc50f3ec4651a2dc1bad5dfe0fa76d3a980 applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: fix crash in refCallback and unrefCallback

Both handlers called fn.ClearWeak() and fn.SetWeak() without checking
whether the persistent handle was still populated. After the callback
function is garbage collected following an earlier unrefCallback()
call, the handle is empty and both V8 methods dereference a null slot.

InvokeCallback() already guarded against this. Add the same check to
both handlers and throw ERR_INVALID_ARG_VALUE, matching the existing
behavior for a pointer that is not in the callback map.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5
PR-URL: https://github.com/nodejs/node/pull/64881
Fixes: https://github.com/nodejs/node/issues/64880
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
