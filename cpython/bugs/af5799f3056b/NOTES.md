Evaluates `ForwardRef("set[undefined]")` with `Format.FORWARDREF`.
Clean: `set[ForwardRef('undefined')]` (re-evals with a stringifier namespace).
Buggy: returns the unevaluated `ForwardRef('set[undefined]')`, because the injection removed that fallback eval.
