code = """\
def f():
    try:
        pass
    %s Exception:
        global a
    else:
        print(a)
"""
for kw in ("except", "except*"):
    try:
        exec(code % kw, {'a': 5}, {})
        print(kw, "ok")
    except SyntaxError as e:
        print(kw, "SyntaxError:", e)
