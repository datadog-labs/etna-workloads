# permission: do not enforce fs and addons in audit mode

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 67a78317dd7de5d8ed7fb3e991ad432d03a3bf19 applied to v26.13.0 (clean).

Upstream commit message:

```
permission: do not enforce fs and addons in audit mode

--permission-audit is documented to perform permission checks without
denying access, publishing each violation through the diagnostics
channel while execution continues. Three code paths still enforced:

* fs.lstat() and fs.symlink() are checked in the JavaScript layer,
  which threw ERR_ACCESS_DENIED without consulting audit mode. The
  isAuditMode() helper introduced for ffi was never wired into fs.
* Addon loading was disabled upfront in Environment setup, so
  process.dlopen() failed with ERR_DLOPEN_DISABLED before reaching
  the audit-aware permission check, and no audit event was published.

Skip the throw in the JavaScript checks when audit mode is on, keeping
the permission.has() call first so the diagnostics channel event is
still published. Leave native addons enabled in audit mode while still
applying the kAddon scope, so DLOpen() publishes the denial through
the channel and continues to the regular loading path. This also
covers the worker path, which inherits kNoNativeAddons from the same
option.

Each fs API carries its own copy of the check in its sync, callback
and promise flavour, so the regression test exercises all six call
sites, asserting the --permission enforce behaviour as a control.

Fixes: https://github.com/nodejs/node/issues/65419
Refs: https://github.com/nodejs/node/pull/63047
Assisted-by: claude:opus-5
Signed-off-by: Ji Hoon Kang <ivory.ma9ic@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65659
Reviewed-By: Rafael Gonzaga <rafael.nunu@hotmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
