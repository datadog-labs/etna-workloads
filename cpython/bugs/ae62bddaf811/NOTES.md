repro.py calls `_testcapi.eval_code_ex` (PyEval_EvalCodeEx) with positional defaults `(1,)` and with kwdefaults `{'a': 1}`.
Clean: prints `1` twice. Buggy: the injection leaves func_defaults/func_kwdefaults NULL when the function is built from the constructor, so both calls raise TypeError (missing argument).
