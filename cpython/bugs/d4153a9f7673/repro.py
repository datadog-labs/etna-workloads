import _testinternalcapi
for arg in ("key", (1, 2, 3), KeyError('arg')):
    try:
        _testinternalcapi._pyerr_setkeyerror(arg)
    except BaseException as e:
        print(type(e).__name__, repr(e.args))
