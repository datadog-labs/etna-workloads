for src in ["res = [super for x in [1]]", "res = [__class__ for x in [1]]"]:
    src = "class C:\n    " + src + "\n    r = res\n"
    try:
        ns = {}
        exec(src, ns)
        print(repr(ns["C"].r))
    except BaseException as e:
        print(type(e).__name__, e)
