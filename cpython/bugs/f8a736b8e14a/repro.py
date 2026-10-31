for name, args in [("__pow__", ()), ("__pow__", (1, 2, 3)), ("__rpow__", ()), ("__rpow__", (1, 2, 3))]:
    try:
        getattr(int(), name)(*args)
    except TypeError as e:
        print(name, len(args), e)
