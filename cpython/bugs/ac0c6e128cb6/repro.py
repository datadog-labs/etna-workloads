for f in (lambda: enumerate(iterable=[5]),
          lambda: enumerate(iterable=[5], start=0),
          lambda: enumerate(start=0, iterable=[5])):
    try:
        print(list(f()))
    except Exception as e:
        print(type(e).__name__, e)
