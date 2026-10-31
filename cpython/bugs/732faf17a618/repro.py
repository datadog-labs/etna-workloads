import dis, io, contextlib
src = """
def f():
    "docstring1"
    def h():
        "docstring2"
        return 42

    class C:
        "docstring3"
        pass

    return h
"""
for opt in [-1, 0, 1, 2]:
    for mode in ["exec", "single"]:
        code = compile(src, "<test>", mode, optimize=opt)
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            dis.dis(code)
        print(opt, mode, 'NOP' in out.getvalue())
