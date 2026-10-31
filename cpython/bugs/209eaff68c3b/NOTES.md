repro.py evaluates a FORWARDREF annotation `global_alias[int]` before `global_alias` exists, then defines the global and re-evaluates the resulting ForwardRef-containing object.
Clean: prints `list[int]`. Buggy: NameError, because the module globals were copied rather than looked up live, so the later global definition isn't seen.
