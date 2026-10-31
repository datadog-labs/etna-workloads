Reproducer: builds an in-memory module whose `fw = ForwardRef('MyDict', module=...)` refers to `dict[str, 'MyList']` (a nested string forward ref), then calls `typing.evaluate_forward_ref(fw)`.

Clean prints `dict[str, list[int]]`. Buggy raises `NameError: name 'MyList' is not defined`, because the injection drops `parent_fwdref=forward_ref` in the recursive evaluation, so the nested ref loses the module of its parent.
