repro.py defines a global and a function that uses it, then calls the function via `Interpreter.call()` in a subinterpreter. That forces the defining script to run there so the function can be unpickled. It then prints whether the subinterpreter's `__main__` now contains `get_count` and `count`.

- clean: `False False`. The script runs in a hidden module, so `__main__` is untouched.
- buggy: `True True`. The names leak into the subinterpreter's real `__main__`.
