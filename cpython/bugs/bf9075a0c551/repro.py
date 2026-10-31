import itertools
for f, a, k in [(itertools.product, (0,), dict(repeat=1, foo=2)),
                (ImportError, (0,), dict(name=1, path=2, name_from=3, foo=3)),
                (min, (0,), dict(default=1, key=2, foo=3))]:
    try:
        f(*a, **k)
    except TypeError as e:
        print(e)
