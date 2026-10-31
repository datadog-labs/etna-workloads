Reproducer for gh-130881 (conditionally defined annotations).

repro.py has an `if` branch that is not taken containing `x: int`, and an else branch with `y: str`. It prints the module's `__annotations__` keys. It also execs code that rebinds `__conditional_annotations__ = 0` and then annotates `z: int`.

Clean: `['y']` and `TypeError`.
Buggy: `['x', 'y']` (annotation from the untaken branch is included) and `no error`.
