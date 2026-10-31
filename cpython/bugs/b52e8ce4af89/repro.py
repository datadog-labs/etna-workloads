import traceback

try:
    compile("女女女=1; 女女女/", "<s>", "exec")
except SyntaxError as e:
    print("".join(traceback.format_exception_only(e)))
