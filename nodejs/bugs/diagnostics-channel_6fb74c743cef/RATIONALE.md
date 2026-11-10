# Rationale

**Bug:** diagnostics_channel's ref counting deleted the channel's entry from the `channels` map when the subscriber count hit zero. The channel object still exists, so a later `subscribe()`/`bindStore()` finds no WeakReference to `incRef` and fails (TypeError). Only GC should remove entries.

**Hunks (both in `WeakRefMap` in lib/diagnostics_channel.js):**
1. `decRef`: deletes the key when the count reaches 0. This corresponds to the fix removing the old `decRef(channel)` helper's `channels.delete(channel.name)` on zero, which the new `WeakRefMap.decRef` comment says must not happen.
2. `incRef`: `super.get(key).incRef()` with no optional chaining. Old `incRef(channel)` was `channels.get(channel.name).incRef()`, so a missing entry threw. The current code's `?.` would hide the bug, so it is removed.

**Failing test:** parallel/test-diagnostics-channel-pub-sub (subscribe, unsubscribe, subscribe again):
`TypeError: Cannot read properties of undefined (reading 'incRef')`. It failed in two consecutive runs.
