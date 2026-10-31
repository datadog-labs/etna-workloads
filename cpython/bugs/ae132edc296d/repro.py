import _warnings
try:
    _warnings._release_lock()
except RuntimeError as e:
    print(repr(e))
