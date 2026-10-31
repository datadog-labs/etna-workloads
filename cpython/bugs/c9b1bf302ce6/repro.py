import ast
try:
    print(repr(ast.parse(ast.Constant(42), optimize=-1)))
except TypeError as e:
    print("TypeError:", e)
