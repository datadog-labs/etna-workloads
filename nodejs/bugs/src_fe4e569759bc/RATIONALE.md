# Re-introduced bug: positional args in task runner (fe4e569759bc)

**Bug.** `node --run script -- a b c` joined all positional arguments after `--` into one string with no separator, so the script received a single merged argument ("abc") instead of separate args.

**Hunk (src/node_task_runner.cc, `GetPositionalArgs`).** This corresponds to the fix's `GetPositionalArgs` hunk, which changed a single concatenated string into a vector of separate `string_view`s. Today's code already uses `PositionalArgs` (a vector), so the old behaviour is restored by concatenating every argument into one static string and returning a one-element vector. `ProcessRunner` then escapes that single element, and the command receives one argument. The fix's other hunks (EscapeShell, the Windows changes, env handling) were left alone because the current code has since moved on and they are not needed for the defect.

**Failing test.** `parallel/test-node-run` fails with "not ok". The 'appends positional arguments' case fails on the merged arguments: it got `Arguments: '--help "hello world test"ABCI think therefore I'm'` where separate arguments were expected; the multi-arg case reports 1 argument instead of 2. I did not run the cctest `TaskRunnerTest.EscapeShell`, because EscapeShell is unchanged and it should still pass.
