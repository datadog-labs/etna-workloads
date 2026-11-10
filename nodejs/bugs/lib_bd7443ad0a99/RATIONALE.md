# CVE-2023-32558: process.binding not restricted under the permission model

**Bug.** With the permission model enabled, `process.binding()` stayed usable. It exposes internal bindings (e.g. `fs`) that bypass the permission checks.

**Change.** Everything is in `lib/internal/process/pre_execution.js`.
- In `initializePermission()` I removed the `process.binding = function binding(_module) { throw new ERR_ACCESS_DENIED('process.binding'); }` override. This matches the fix's hunk that added it (today's guard is `--permission`, not `--experimental-permission`).
- I removed the `ERR_ACCESS_DENIED` import, which the fix's first hunk added and which would otherwise be unused.

**Failing test.** `parallel/test-permission-processbinding` reports `not ok` on both runs. `process.binding()` throws `Error: No such module: undefined` instead of `ERR_ACCESS_DENIED`.
