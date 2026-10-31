import ast
src = """\
with (a as b):  # type: int
    pass

with (a, b):  # type: int
    pass
"""
try:
    tree = ast.parse(src, type_comments=True)
    print([s.type_comment for s in tree.body])
except SyntaxError as e:
    print("SyntaxError", e)
