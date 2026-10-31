import ast
for src in ['f"{x:\\\\ }"', 'f"{x:\\\\\\\\ }"', "f\"{x:'}\"", "f\"{x:\\\\'}\""]:
    tree = ast.parse(src)
    out = ast.unparse(tree)
    print(repr(src), repr(out))
    try:
        print(ast.dump(ast.parse(out)) == ast.dump(tree))
    except SyntaxError as e:
        print("SyntaxError", e)
