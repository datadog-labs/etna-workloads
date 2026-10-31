Wraps a plain generator with `types.coroutine` (giving `types._GeneratorWrapper`) and calls
`inspect.getgeneratorstate`/`getcoroutinestate` before and after `next()`.
Clean: prints CREATED/SUSPENDED states. Buggy: the wrapper lacks `gi_suspended`/`cr_suspended`/`gi_state`,
so AttributeError is raised (or the results differ).
