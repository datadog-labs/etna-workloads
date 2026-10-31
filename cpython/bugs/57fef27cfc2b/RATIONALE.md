# Rationale

Fix hunk reversed: in `evaluate_forward_ref` (Lib/typing.py), the fix removed the
`_type_check(value, "Forward references must evaluate to types.", is_argument=...,
allow_special_forms=forward_ref.__forward_is_class__)` call on the evaluated value.
I re-added it in v3.15.2 (before the recursive `_eval_type`, which now receives `type_`).
The NameError/FORWARDREF handling already lives in `ForwardRef.evaluate(format=...)` in
v3.15.2, so only the validation step was restored.

Effects (same as pre-fix): ClassVar[int] at module level / in function annotations raises
TypeError instead of being returned (gh-133959), `Final[int]` nested in `list[...]` is rejected,
and `'None'` evaluates to `NoneType` rather than `None`.

Failing oracle cases: EvaluateForwardRefTests.test_evaluate_forward_ref_none
(NoneType is not None), plus the two TypeError errors in
test_top_level_class_var / test_special_forms_no_forward / test_special_forms_forward.
