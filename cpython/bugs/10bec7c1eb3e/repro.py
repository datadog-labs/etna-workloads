for v in (1.0, ""):
    it = iter(range(10, 2**65, 2))
    try:
        it.__setstate__(v)
    except TypeError as e:
        print("TypeError", e)
