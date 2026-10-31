import ast
for src in ("try:\n    ...\nexcept ValueError, TypeError:\n    ...\n",
            "try:\n    ...\nexcept* ValueError, TypeError:\n    ...\n"):
    try:
        ast.parse(src, feature_version=(3, 13))
        print("parsed")
    except SyntaxError as e:
        print("SyntaxError:", e.msg)
