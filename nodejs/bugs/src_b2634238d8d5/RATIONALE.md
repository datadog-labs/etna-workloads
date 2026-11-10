# Re-introduced bug: coverage not written on fatal uncaught exception

## Bug
When a script throws an uncaught exception in the first tick, the fatal path in
`TriggerUncaughtException` exited without ending the started inspector profilers
(coverage, cpu, heap). NODE_V8_COVERAGE output was therefore never written.

## Change
`src/node_errors.cc`, `TriggerUncaughtException` (fatal path): removed the `RunAtExit(env);`
call after `ReportFatalException(...)`.

The upstream fix added `profiler::EndStartedProfilers(env)` at that spot. In today's tree
that function is static and is run through the `AtExit` hook registered in
`StartProfilers`, which is triggered by `RunAtExit(env)` at the same place. Removing the
call restores the pre-fix behaviour: the profilers are not ended before `env->Exit()`.
Other at-exit hooks are also skipped on this path, as they were before the fix.

## Failing test
`parallel/test-v8-coverage` fails (checked in 3 runs; the two repeat runs showed only "not ok"):
```
Error: ENOENT: no such file or directory, scandir '.../.tmp.0/cov_2'
    at getFixtureCoverage (test/parallel/test-v8-coverage.js:196:28)
    at test/parallel/test-v8-coverage.js:48:27
```
This is the "Outputs coverage when error is thrown in first tick" case. No coverage
directory is written.
