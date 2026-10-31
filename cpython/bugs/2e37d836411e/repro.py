import marshal
def f():
    return 1234.5
c = f.__code__
a = []
code = c.replace(co_consts=c.co_consts + (a,))
a.append(code)
objs = {"code": code}
s = slice([], None); s.start.append(s); objs["slice"] = s
fd = frozendict({None: []}); fd[None].append(fd); objs["frozendict"] = fd
for n, o in objs.items():
    for v in range(marshal.version + 1):
        try:
            marshal.dumps(o, v)
            print(n, v, "no error")
        except ValueError as e:
            print(n, v, "ValueError")
        except BaseException as e:
            print(n, v, type(e).__name__)
