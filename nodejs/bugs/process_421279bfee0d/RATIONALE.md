# Bug
`process.setuid/seteuid/setgid/setegid(-0)` aborts the process. `-0` passes the JS validation
(`validateUint32` accepts it) but V8 does not treat `-0` as a Uint32, so the C++ side's
`CHECK(args[0]->IsUint32() || args[0]->IsString())` fails (node_credentials.cc).

# Change
`lib/internal/bootstrap/switches/does_own_process_state.js`, `wrapIdSetter`: removed the line
`if (typeof id === 'number') id >>>= 0;` (the release's form of the fix's added
`if (typeof id === 'number') id |= 0;`). That normalisation turned -0 into +0 before calling the
native setter; without it -0 reaches C++ and trips the assertion.

# Failing test
parallel/test-process-uid-gid: "not ok", process aborts with
`Assertion failed: args[0]->IsUint32() || args[0]->IsString()` at src/node_credentials.cc:336
(called from test line 61, `process.setuid(-0)`).
