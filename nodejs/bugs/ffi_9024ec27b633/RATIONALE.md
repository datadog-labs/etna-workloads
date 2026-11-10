# ffi: keep FFI functions non-constructible

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9024ec27b6333e5cd2bea5ce890fc2ff6fbab84f applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: keep FFI functions non-constructible

Use concise method functions for Fast API and shared-buffer wrappers,
and create native fallback functions with ConstructorBehavior::kThrow,
so FFI functions remain non-constructible on all invocation paths.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65184
Fixes: https://github.com/nodejs/node/issues/65183
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
