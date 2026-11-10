# ffi: validate DynamicLibrary getter receivers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bdcb6def4e6e4abd67842cc88405bb917073040c applied to v26.13.0 (fuzzy).

Upstream commit message:

```
ffi: validate DynamicLibrary getter receivers

Bind the path, symbols, and functions getter templates to the
DynamicLibrary constructor signature. This causes V8 to reject
incompatible receivers before invoking the native callbacks,
preventing them from crashing the process.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65415
Fixes: https://github.com/nodejs/node/issues/65287
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
