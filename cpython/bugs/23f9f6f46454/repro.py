import ast
src = "f\"'''{1}\\\"\\\"\\\"\" "
tree = ast.parse(src)
try:
    out = ast.unparse(tree)
    print(repr(out))
    print(ast.dump(ast.parse(out)) == ast.dump(tree))
except Exception as e:
    print(type(e).__name__, e)
