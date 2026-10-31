src = b"# coding: utf-8\nx = 1\n\xff = 2\n"
try:
    compile(src, "t.py", "exec")
except SyntaxError as e:
    print(type(e).__name__, e.msg, e.lineno, e.offset)
try:
    compile(b"x = 1\ny = '\xff'\n", "t.py", "exec")
except SyntaxError as e:
    print(type(e).__name__, e.msg, e.lineno, e.offset)
