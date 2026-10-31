import ast
for src in ["f'{1:{name}}'", "f'{1:{name1}{name2}}'"]:
    fv = ast.parse(src).body[0].value.values[0]
    print([type(v).__name__ for v in fv.format_spec.values])
