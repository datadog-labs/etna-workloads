import pkgutil
for p in ('test_dir', b'test_dir'):
    try:
        print(repr(list(pkgutil.walk_packages(p))))
    except (TypeError, ValueError) as e:
        print(type(e).__name__, e)
