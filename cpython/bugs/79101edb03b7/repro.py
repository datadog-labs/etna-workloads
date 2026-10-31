import ast
m = ast.Module(
    body=[ast.Expr(value=ast.ListComp(
        elt=ast.NamedExpr(target=ast.Constant(value=1), value=ast.Constant(value=3)),
        generators=[ast.comprehension(target=ast.Name(id="x", ctx=ast.Store()),
                                      iter=ast.Name(id="y", ctx=ast.Load()),
                                      ifs=[], is_async=0)]))],
    type_ignores=[])
try:
    compile(ast.fix_missing_locations(m), "<file>", "exec")
except TypeError as e:
    print("TypeError:", e)
