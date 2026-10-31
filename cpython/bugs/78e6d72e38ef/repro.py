import traceback
try:
    compile('print("你好", 1 +)', "<s>", "exec")
except SyntaxError as e:
    print("".join(traceback.format_exception_only(e)))
try:
    exec('x = "你好" + 1 +')
except SyntaxError as e:
    print("".join(traceback.format_exception_only(e)))
