import ast, textwrap
code = textwrap.dedent("""
    if name_2:
        pass
    else:
        try:
            pass
        except:
            pass
    ~name_5
    """)
tree = ast.parse(code)
for node in ast.walk(tree):
    if hasattr(node, "lineno"):
        del node.lineno
        del node.end_lineno
        del node.col_offset
        del node.end_col_offset
co = compile(ast.fix_missing_locations(tree), "<file>", "exec")
print("compiled", len(co.co_code))
