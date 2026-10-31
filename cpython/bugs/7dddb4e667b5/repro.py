import ast, copy
node = ast.FunctionDef(name="foo", args=ast.arguments())
try:
    node2 = copy.replace(node, name="bar")
    print(node2.name, repr(node2.returns), node2.decorator_list)
except Exception as e:
    print(type(e).__name__, e)
