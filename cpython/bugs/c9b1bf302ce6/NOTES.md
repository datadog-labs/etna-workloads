Calls `ast.parse(ast.Constant(42), optimize=-1)` (AST input of the wrong root type, unoptimized path).
Clean: raises `TypeError: expected Module node, got Constant`.
Buggy: the unoptimized path returns the input object unchecked, so the Constant is printed.
