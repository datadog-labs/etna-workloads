import ast
source = "0x0" + "e" * 10_000
try:
    repr(ast.Constant(value=eval(source)))
except ValueError as e:
    print(type(e).__name__, str(e)[:30])
