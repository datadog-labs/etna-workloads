try:
    compile("if 1:\n    raise AssertionError() from None\n    print(1,,2)\n", "<s>", "exec")
except SyntaxError as e:
    print(e.msg, e.lineno)
