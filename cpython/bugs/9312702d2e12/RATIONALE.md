# Rationale

## Lib/typing.py, `evaluate_forward_ref`
Reverses the fix hunk that added `parent_fwdref=forward_ref` to the `_eval_type(...)` call
at the end of `evaluate_forward_ref`. In v3.15.2 the `parent_fwdref` parameter, the
`_make_forward_ref` handling and the `_eval_type` GenericAlias use all still exist, but
without this argument the nested string args (e.g. `'MyList'` in `dict[str, 'MyList']`)
get forward refs that lack the parent's `module`/`owner`, as before the fix.
(The other three hunks were left intact; the argument is what makes them reachable.)

## Oracle failure
`test_typing` `ForwardRefTests.test_with_module` (the new test) fails with
`NameError: name 'MyList' is not defined`, which is what the fix guards against.
