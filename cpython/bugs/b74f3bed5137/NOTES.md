repro.py parses a class whose body is only a docstring with ast.parse(optimize=2) and dumps the AST. Clean: body=[Pass()]. Buggy: the docstring is removed leaving an empty body (ClassDef(name='A')).
