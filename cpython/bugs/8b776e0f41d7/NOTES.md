repro.py calls a singledispatchmethod method with no positional args; clean raises TypeError 't requires at least 1 positional argument', buggy raises IndexError (tuple index out of range).
