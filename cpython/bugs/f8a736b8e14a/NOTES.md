repro.py calls int().__pow__ and int().__rpow__ with 0 and 3 arguments and prints the TypeError message.

- Clean: "expected 1 or 2 arguments, got N".
- Buggy: the old PyArg_UnpackTuple message with an empty function name, e.g. " expected at least 1 argument, got 0" and " expected at most 2 arguments, got 3".
