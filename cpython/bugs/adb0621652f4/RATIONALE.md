# Rationale

Reverses the `_collect_parameters` hunk of fix.patch (now `_collect_type_parameters` in Lib/typing.py):
removed the `elif isinstance(t, tuple)` branch that recursively collects type parameters from a tuple
(a ParamSpec substituted with `[int, T]`, `[*Ts, int]`, ...). Pre-fix, such a tuple fell into the generic
`else` branch, which finds no `__parameters__`, so `Base[[int, T]].__parameters__` is `()`
and the TypeVar cannot be substituted later.

The `_make_substitution` hunk is left intact; it is unreachable for these cases without the parameters.

Failing oracle cases: on the first ./check.sh run, test_typing ran 742 tests with 3 failures, including
`test_nested_paramspec` (parameter order `(~P2, ~T2)` instead of `(~T2, ~P2)`); the added
`test_type_var_subst_for_other_type_vars` is expected to fail since `__parameters__` is wrong.
Later ./check.sh runs reported all oracle cases failing with empty output (a harness/run problem I could not diagnose),
so I did not confirm the exact names of the other failures.
