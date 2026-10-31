import _sre
for t in (["", -1, ""], ["", (), ""]):
    try:
        _sre.template("", t)
    except TypeError as e:
        print(e)
