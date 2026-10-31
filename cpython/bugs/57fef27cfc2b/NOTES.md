Reproducer calls `typing.evaluate_forward_ref(ForwardRef('None'))`.
Clean: prints `None`. Buggy: the injected `_type_check` call on the evaluated value changes the result (it converts None to `type(None)`, printing `<class 'NoneType'>`), so it differs.
