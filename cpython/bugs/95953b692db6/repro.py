import ast

class BadFields(ast.AST):
    _fields = (b'\xff' * 8,)
    _field_types = {'a': int}

try:
    BadFields()
except TypeError as e:
    print(repr(e))
