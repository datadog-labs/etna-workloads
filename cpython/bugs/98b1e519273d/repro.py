try:
    code = compile(b"#coding=U7+AA0''\n", "x.py", "exec")
    print(repr(code.co_consts))
except BaseException as e:
    print(type(e).__name__, e)
