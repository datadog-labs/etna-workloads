import _imp
try:
    _imp.get_frozen_object("x", b"6\'\xd5Cu\x12")
except ImportError as e:
    print(repr(e))
