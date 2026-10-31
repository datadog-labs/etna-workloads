import _csv
for tp in _csv.Reader, _csv.Writer:
    try:
        tp()
        print(tp.__name__, "instantiated")
    except TypeError as e:
        print(tp.__name__, "TypeError:", e)
