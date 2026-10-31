Evaluates `ForwardRef("int").evaluate()` with no globals. Clean: prints `<class 'int'>`.
Buggy: the `globals = {}` fallback is removed, so `arg in globals` raises TypeError (NoneType is not a container).
