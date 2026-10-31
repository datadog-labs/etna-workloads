# Rationale

Fix (gh-143999) added `gi_suspended`/`cr_suspended` delegation to `types._GeneratorWrapper`, so
`inspect.getgeneratorstate`/`getcoroutinestate` (which then read `gi_suspended`/`cr_suspended`) worked on
`types.coroutine`-wrapped generators.

In v3.15.2 `inspect` reads `gen.gi_state` / `coro.cr_state` instead, and the wrapper delegates those too
(same defect class: wrapper state delegation). Reverting only `gi_suspended` would not bring the bug back.

Change (Lib/types.py, `_GeneratorWrapper`): removed `gi_suspended`, `cr_suspended = gi_suspended`
(the exact fix hunk), plus `gi_state` and `cr_state` (the current-day delegation of the suspended/state
info that inspect now uses). Result: the wrapper lacks the state attributes, as before the fix.

Oracle: `test_inspect.test_inspect` `test_types_coroutine_wrapper_state` fails with AttributeError
from `inspect.getgeneratorstate(g)` on a `types._GeneratorWrapper`.
