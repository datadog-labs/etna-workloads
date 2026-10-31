import ast
fv = ast.parse("f'{expr:}'").body[0].value.values[0]
print(ast.dump(fv.format_spec))
print(len(fv.format_spec.values))
