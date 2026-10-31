import ast
node = ast.TemplateStr(
    [ast.Interpolation(value=ast.Name(id="test1"), str=None, conversion=-1)]
)
print(repr(ast.unparse(node)))
