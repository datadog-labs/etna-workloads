# Rationale

Fix: gh-141999, handle KeyboardInterrupt in `SampleProfiler.sample`.

## Change: `tree/Lib/profiling/sampling/sample.py`

Removed the `except KeyboardInterrupt:` clause (which set `interrupted = True`,
recomputed `running_time_sec`, and printed "Interrupted by user.") from the
sampling loop's `try`/`finally`. This reverses the fix's added
`try: ... except KeyboardInterrupt:` wrapper. In v3.15.2 the loop was already
wrapped in `try/finally` (for `flush_pending`), so removing the handler restores
the pre-fix behaviour: Ctrl-C propagates out of `sample()` instead of ending
sampling cleanly with a stats summary. The `not interrupted` condition on the
missed-samples warning is left in place; it is now dead code since `interrupted`
is never set.

## Oracle failure

`TestSampleProfiler.test_sample_profiler_keyboard_interrupt` fails with
"KeyboardInterrupt was not handled by the profiler". The other 28 cases pass.
