import ast
m = ast.Module(
    body=[ast.TypeAlias(
        name=ast.Subscript(value=ast.Name(id="foo", ctx=ast.Load()),
                           slice=ast.Constant(value="x"), ctx=ast.Store()),
        type_params=[],
        value=ast.Name(id="Callable", ctx=ast.Load()))],
    type_ignores=[])
try:
    compile(ast.fix_missing_locations(m), "<file>", "exec")
except TypeError as e:
    print("TypeError:", e)
