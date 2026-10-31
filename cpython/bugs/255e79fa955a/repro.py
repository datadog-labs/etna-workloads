import ast
tree = ast.parse("{**x for x in ()}")
print(ast.unparse(tree))
