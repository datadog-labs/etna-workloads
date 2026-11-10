# Re-introduced bug: http socket re-use races (fix 8700d89306)

**Bug.** A keep-alive socket in the Agent free pool that timed out (or was destroyed but whose 'close' had not yet fired) could be handed to a new request, causing unexpected failures. Nothing destroyed a free socket on 'timeout', and addRequest did not skip destroyed free sockets.

**Hunks (all in lib/_http_agent.js)**
1. Removed `onTimeout` and `s.on('timeout', onTimeout)` in installListeners, plus its `removeListener` in `onRemove`. This reverses the fix hunks that added them. Timed-out free sockets are no longer destroyed.
2. Removed the `while (freeSockets.length && freeSockets[0].destroyed) shift()` loop in addRequest. This reverses the fix's destroyed-socket skipping, so destroyed sockets can be reused. The current code has this loop in a refactored form.
3. Restored the `req.once('response', ... res.once('end', ... socket.setTimeout(agentTimeout)))` block in setRequestSocket. This reverses the fix's removal of it. The fix's other hunk (resetting the timeout when a socket goes to the free list) has no counterpart today, because keepSocketAlive() now does that. I left it alone.

**Failing tests** (stable over 2 runs; all 6 oracle cases are "not ok"): test-http-agent-timeout, test-http-agent-timeout-option, test-http-client-set-timeout, test-http-client-set-timeout-after-end, test-http-client-timeout-option-listeners, test-http-client-timeout-option-with-agent. The listener-count tests expect 2 'timeout' listeners (or 1 after setTimeout(0)) and now see 1 (or 0). I did not record the exact assertion messages. test-http-agent-timeout fails because timed-out sockets are reused.
