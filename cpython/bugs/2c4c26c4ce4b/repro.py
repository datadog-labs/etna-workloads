import ast
src = '''f"{'\\n'}"'''
print(src)
try:
    print(repr(ast.unparse(ast.parse(src))))
except Exception as e:
    print(type(e).__name__, e)
