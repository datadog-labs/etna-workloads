# Rationale

**Bug:** `diagnostics_channel.hasSubscribers(name)` called a wrong method on the looked-up value (`ref.get()` on a WeakRef instead of `WeakRefPrototypeGet`), so it threw a TypeError whenever a channel with that name existed.

**Hunk (lib/diagnostics_channel.js, `hasSubscribers`):** corresponds to the fix's single implementation hunk (`ref.get()` -> `WeakRefPrototypeGet(ref)`). Today `channels` is a `WeakRefMap` whose `get()` already dereferences and returns the Channel, so I re-introduced the defect as `channels.get(name)?.get()`. That calls a nonexistent `.get` on the Channel object, which throws when the channel exists. The unused-primordial import hunk has no equivalent today.

**Failing test:** `parallel/test-diagnostics-channel-has-subscribers` fails (stable across 2 runs): `TypeError: channels.get(...)?.get is not a function`.
