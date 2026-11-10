# Re-introduced bug: duplicates in transfer list not rejected

Bug: `postMessage(value, [x, x])` with a duplicated ArrayBuffer or MessagePort no longer throws
`DataCloneError`. Instead the duplicate is processed twice (a MessagePort is detached twice,
hitting the `CHECK(data_)` in `MessagePort::Detach()` and aborting the process; ArrayBuffers get
registered twice).

## Hunks (all in src/node_messaging.cc, `Message::Serialize`)
1. Removed the `std::ranges::find(array_buffers, ab)` duplicate check that threw
   "Transfer list contains duplicate ArrayBuffer". Corresponds to the fix's first hunk.
2. Removed the `std::ranges::find(delegate.host_objects_, host_object)` duplicate check that threw
   "Transfer list contains duplicate <ctor name>" (today's generalised form of the fix's
   duplicate MessagePort check, second hunk).
The fix's third hunk (`CHECK(data_)` in `Detach()`) is already present in the release and is
kept; it is what turns the missing check into an abort.

## Failing test
parallel/test-worker-message-port-transfer-duplicate: `not ok`, severity crashed, exitcode -6,
`Assertion failed: data_` in `MessagePort::Detach()` (node_messaging.cc), from the
`port1.postMessage(port3, [port3, port3])` case. Stable across two runs.
