# Re-introduced bug: agent timeout set in 'free' handler instead of keepSocketAlive

**Bug.** The agent's default socket timeout was applied in the Agent constructor's `'free'` listener, which runs after `keepSocketAlive()`. It overwrote any timeout a custom Agent's `keepSocketAlive` override set (e.g. `socket.setTimeout(CUSTOM)` after `super.keepSocketAlive()`).

**Changes (lib/_http_agent.js).**
- Hunk 1 (fix hunk 1, reversed): re-added the `agentTimeout`/`socket.setTimeout(agentTimeout)` block in the `'free'` handler, after `removeSocket`. It runs after the custom keepSocketAlive, so it clobbers the custom timeout.
- Hunk 2 (fix hunk 2, reversed): removed the `socket.setTimeout` block from the end of `Agent.prototype.keepSocketAlive` (which in today's code also applies the server keep-alive hint). The hint-derived `agentTimeout` there is now computed but unused, which is the pre-fix behaviour: keepSocketAlive did not set the timeout.

**Failing test.** `parallel/test-http-agent-timeout` fails ("not ok 1") in two consecutive runs. The new custom-keepSocketAlive case sees `socket.timeout` equal to the agent timeout (50) rather than the custom 60.
