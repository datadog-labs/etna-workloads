import dis, io
def f():
    print(a)
out = io.StringIO()
dis.disassemble(f.__code__, 6, file=out)  # offset 6: CACHE entry of LOAD_GLOBAL at 4
print([l.split("-->")[1].split()[0] for l in out.getvalue().splitlines() if "-->" in l])
