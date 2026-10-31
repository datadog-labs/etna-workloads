import warnings
for f, a, k in [(warnings.filterwarnings, ('foo',), {}),
                (warnings.filterwarnings, ('ignore',), {'category': int}),
                (warnings.simplefilter, ('ignore',), {'lineno': -1})]:
    try:
        f(*a, **k)
    except Exception as e:
        print(type(e).__name__, e)
