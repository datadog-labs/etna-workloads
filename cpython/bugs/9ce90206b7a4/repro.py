import tomllib
for v in (b"v = 1", False):
    try:
        tomllib.loads(v)
    except Exception as e:
        print(type(e).__name__, e)
