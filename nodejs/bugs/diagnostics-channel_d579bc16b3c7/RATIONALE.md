# diagnostics_channel memory leak (d579bc16)

**Bug:** channel references were leaked: after `unsubscribe`, the channel's `WeakReference` kept a nonzero
refcount (strong reference), so the Channel object could never be garbage collected / cleaned from the `channels` map.
The upstream fix called `decRef()` and deleted the map entry when the refcount hit 0. (Today's code has since
been restructured: `WeakRefMap` + finalization registry, and the `getRef`/`delete channels[name]` hunks no longer exist.)

**Change (one hunk, lib/diagnostics_channel.js):** removed `channels.decRef(this.name)` from
`ActiveChannel.unsubscribe`. This corresponds to the fix's lib hunk (the decRef/cleanup on unsubscribe): without it the
refcount never drops to 0 after unsubscribing, so the channel stays strongly held and leaks. The C++ `GetRef` hunk
was only support for the lib-side delete, which is not present in today's code, so it is not re-expressed.

**Failing test:** parallel/test-diagnostics-channel-memory-leak (not ok: Channel objects are not collected after
unsubscribe; test times out/fails its collection check). Failure stable over 2 runs.
