# Re-introduced bug: nested tests not counted

Bug: the test runner summary (`# tests`, `# pass`, `# fail`, ...) only counted top-level tests
when a child test file's TAP/event stream was processed; nested subtests were ignored
(upstream issue #46762).

Change (lib/internal/test_runner/runner.js, `FileTest#handleReportItem`): the call to
`countCompletedTest(...)` is now guarded by `isTopLevel` (nesting === 0). This corresponds to the
fix hunk that replaced the `if (nesting === 0) { ...countSubtest... }` counting with an
unconditional `countCompletedTest` for every reported test; restoring the nesting guard brings back
the old behaviour. (The other hunks of the fix have no remaining old-code equivalent.) A redundant extra pair of parentheses was also added to the `if` condition (no-op).

Failing: parallel/test-runner-cli — `The input did not match /# tests 8/. Input: '# tests 4 # pass 2 # fail 2'`.
