# Re-introduced bug: net family autoselection timeout handling (2d24b29cf46b)

## Bug
Before the fix, a timed-out attempt in `internalConnectMultiple` set a context-wide
`kTimeoutTriggered` flag that was never reset. Any later completion (including a
successful connect to the last address) was ignored and its handle closed, so
autoSelectFamily could hang or fail. The timed-out attempt's handle was also not
closed, and the attempt timer was armed even for the last address.

## Changes (lib/net.js)
1. Re-added `kTimeoutTriggered` symbol and `[kTimeoutTriggered]: false` in the context
   (reverses the fix's removal hunks).
2. `internalConnectMultiple`: always start the attempt timer, not only when
   `current < addresses.length - 1` (reverses the fix's last hunk there).
3. `afterConnectMultiple`: ignore completions when `context[kTimeoutTriggered]` is set,
   instead of `status === 0 && current !== context.current - 1`; `clearTimeout` moved
   back after that check (reverses the fix's hunk).
4. `internalConnectMultipleTimeout`: set `context[kTimeoutTriggered] = true` instead of
   `req.oncomplete = undefined; handle.close()`.
Today's code differs from the fix's era (`current` is already computed via
`context.current++`, handle reinitialisation, error/event emission), so those parts were kept.

## Test result
`parallel/test-net-autoselectfamily` still PASSES with this change in this sandbox
(build succeeded). The sandbox has no network, so connects to the test's unreachable
addresses (104.20.x.46) fail immediately instead of timing out; the timeout path that
the bug lives in is therefore never exercised. I could not produce a failing test here.
