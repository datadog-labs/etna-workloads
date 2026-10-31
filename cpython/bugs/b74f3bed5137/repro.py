import ast
src = 'class A:\n    """Docstring"""\n'
t = ast.parse(src, optimize=2)
print(ast.dump(t))
