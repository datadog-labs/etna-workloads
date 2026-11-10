# Re-introduced bug: infinite recursion of run() with undefined files (f801b58e7753)

**Bug.** When `run()` is called with `files: undefined` inside a process that is itself a test-runner child (`NODE_TEST_CONTEXT` set), it globs for test files and spawns them. Those children do the same, so the runner recurses without end (hang or infinite loop).

**Change.** One hunk in `lib/internal/test_runner/runner.js`. I removed the `process.env.NODE_TEST_CONTEXT !== undefined` guard (warning, `root.postRun()`, `return root.reporter`). In the release that guard sits inside `if (isolation === 'process')`. The fix added an equivalent early return right after `createTestTree`. Without it, `run()` goes on to `createTestFileList` and spawns files. This restores the pre-fix behaviour.

**Result.** `parallel/test-runner-run` fails on every run. It times out after 120s (`exitcode -15`, `timeout`), with MaxListenersExceededWarning from the recursive runs. The failing cases are the "should run with no files" ones. The clean release passes.
