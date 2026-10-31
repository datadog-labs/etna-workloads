import ast
try:
    print(ast.dump(ast.parse("try:\n    pass\nexcept A:\n    pass\n", feature_version=(3, 13))))
except SyntaxError as e:
    print("SyntaxError", e)
try:
    print(ast.dump(ast.parse("try:\n    pass\nexcept* A:\n    pass\n", feature_version=(3, 13))))
except SyntaxError as e:
    print("SyntaxError", e)
