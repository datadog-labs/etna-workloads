for typ in [list[int], tuple[int, str]]:
    for cls in (object, type):
        try:
            r = issubclass(typ, cls)
        except TypeError:
            r = "TypeError"
        print(typ, cls.__name__, r)
