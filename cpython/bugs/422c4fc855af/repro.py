import sys
from unittest.mock import patch, MagicMock

def _inaccessible(*args, **kwargs):
    raise AttributeError

class OpaqueProxy:
    __getattribute__ = _inaccessible

sys.modules[__name__].g = OpaqueProxy()

@patch(__name__ + ".g", new_callable=MagicMock())
def test(_):
    pass

try:
    test()
    print("ok")
except BaseException as e:
    print(type(e).__name__, e)
