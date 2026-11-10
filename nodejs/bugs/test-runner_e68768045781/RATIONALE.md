# Suite rerun bug

Bug: when a test/suite is replayed from the rerun-failures state file, synthetic children are created and `.start()`ed without start/end times being set, and (in today's code) suites' children are started both by the replay fn and by Suite.run(). Reruns of `describe` blocks therefore misbehave (children run twice / bad timings, wrong pass counts).

Change (lib/internal/test_runner/test.js, replay `this.fn` loop): corresponds to the fix's single hunk, which added `t.endTime = t.startTime = hrtime(); t.start();` in place of `createSubtest(...).start()`. Re-expressed for today's code, I removed the `t.startTime`/`t.endTime` assignment and the `reportedType !== 'suite'` guard, leaving an unconditional `t.start()` as before the fix.

Failing test: parallel/test-runner-test-rerun-failures ("not ok", stable across 2 runs; the counts / state file assertions on the rerun stdout fail).
