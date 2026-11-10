# Rationale

**Bug:** vm module instantiate errors did not identify which module failed. When a module's dependency was not linked, the error read `request for 'X' is from a module not been linked`, with no module identifier. That made it hard to find the offending module.

**Change (src/module_wrap.cc, `ModuleWrap::ResolveModule`, the `!dependent->IsLinked()` branch):**
This corresponds to the fix's hunk that rewrote the "not linked" `THROW_ERR_VM_MODULE_LINK_FAILURE` message to include `dependent->url_`. I restored the old message, `request for '%s' is from a module not been linked`, which takes only the specifier. The `url_` field already exists in this release, so the other fix hunks (the field move, the `node_errors.h` change) were left alone. They only refactor storage, and the old defect is purely the message text. The release no longer has the "not in cache" branch the fix touched, so no hunk was needed for it.

**Failing test:** `parallel/test-vm-module-linkmodulerequests` fails with "instantiate error should hint about module identifier". The expected message is `request for 'unknown' can not be resolved on module 'file://bar' that is not linked`. The actual message is `request for 'unknown' is from a module not been linked`. The failure was the same on both runs.
