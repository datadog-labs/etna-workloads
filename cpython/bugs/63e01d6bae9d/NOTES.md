repro.py: a class annotation `x: global_alias[int]` is evaluated as a ForwardRef (FORWARDREF format) while `global_alias` is undefined, then the global is defined and the resulting object is evaluated again.
Clean: prints `list[int]`. Buggy: the injection copies globals when injecting type params, so the later definition isn't seen and it raises NameError.
