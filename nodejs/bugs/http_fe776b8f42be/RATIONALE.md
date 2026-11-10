# Bug
Agent#createSocket did not pass keepAlive / keepAliveInitialDelay to createConnection, so sockets created through a custom/overridden createConnection (and the options object it sees) lacked the agent's keep-alive settings.

# Change
lib/_http_agent.js: removed the block `if (this.keepAlive) { options.keepAlive = ...; options.keepAliveInitialDelay = this.keepAliveMsecs; }` before `this.createConnection(options, oncreate)`. This is the single hunk of the fix, reversed (re-applied at its new location).

# Failing test
parallel/test-http-agent-keepalive-delay: assertion fails, `options.keepAlive` is undefined (actual: undefined, expected: true / 1000). Failed in 2 runs.
