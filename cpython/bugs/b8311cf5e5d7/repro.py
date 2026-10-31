for name in ("values", "items"):
    d = {0: 0}
    n = 0
    try:
        for _ in getattr(d, name)():
            del d[0]
            d[0] = 0
            n += 1
            if n >= 100:
                break
    except RuntimeError as e:
        print(name, "RuntimeError:", e)
    print(name, "iterations:", n)
