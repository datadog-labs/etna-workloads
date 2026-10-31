import ast, warnings
src = "def f():\n    try:\n        pass\n    finally:\n        return 1\n"
with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    ast.parse(src)
print([str(x.message) for x in w])
