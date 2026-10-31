Reads a config with allow_no_value=True where a valueless key (`KEY1`) is followed by an indented line (` KEY2 = VAL2`).
Clean: raises MultilineContinuationError. Buggy: no error; the indented line is parsed silently (printed dict of sections).
