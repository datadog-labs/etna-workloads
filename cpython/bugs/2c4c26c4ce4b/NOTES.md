Unparses `f"{'\n'}"` (backslash inside an f-string expression, valid since PEP 701) with ast.unparse.
Clean: returns `f"{'\n'}"` source. Buggy: raises ValueError "Unable to avoid backslash in f-string expression part".
