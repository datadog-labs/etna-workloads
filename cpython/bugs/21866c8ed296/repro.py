import ast, textwrap
code = textwrap.dedent("""
    try:
        pass
    except:
        pass
    else:
        match name_2:
            case b'':
                pass
    finally:
        something
    """)
tree = ast.parse(code)
for node in ast.walk(tree):
    if hasattr(node, "lineno"):
        del node.lineno
        del node.end_lineno
        del node.col_offset
        del node.end_col_offset
compile(ast.fix_missing_locations(tree), "<file>", "exec")
print("ok")
