# ffi: remove permission checks from dlclose and dlsym

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 53fd8e7ebbc42fc4b698f1e125c3e7cbd053b2fa applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: remove permission checks from dlclose and dlsym

The docs describe `ffi.dlclose(handle)` and `ffi.dlsym(handle, symbol)`
as equivalent to `handle.close()` and `handle.getSymbol(symbol)`, but
only the functions called `checkFFIPermission()`. After
`process.permission.drop('ffi')`, `ffi.dlclose(lib)` threw
`ERR_ACCESS_DENIED` while `lib.close()` succeeded.

Remove the checks so the functions defer to the handle. Permission is
already checked when the `DynamicLibrary` is constructed, and dropping
a permission does not revoke resources that are already open.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66426
Fixes: https://github.com/nodejs/node/issues/66425
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
