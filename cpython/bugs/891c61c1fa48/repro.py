for src in ("class A[__classdict__]: pass",
            "def f[__classdict__](): pass",
            "type T[__classdict__] = tuple[__classdict__]"):
    try:
        compile(src, "<t>", "exec")
        print("compiled")
    except SyntaxError as e:
        print(e.msg)
