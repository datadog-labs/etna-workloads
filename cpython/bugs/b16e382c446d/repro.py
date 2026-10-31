for view in ({}.keys(), {}.items()):
    try:
        print(repr(view & 1))
    except TypeError as e:
        print("TypeError")
