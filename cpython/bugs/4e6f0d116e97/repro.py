import _interpreters
i = _interpreters.create()
for v in (1, None):
    try:
        _interpreters.set___main___attrs(i, v)
    except BaseException as e:
        print(type(e).__name__, e)
    else:
        print("no error")
_interpreters.destroy(i)
