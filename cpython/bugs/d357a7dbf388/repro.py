from unittest import mock

def foo(x: Undefined[int, ...]) -> None:
    pass

try:
    mock.create_autospec(foo)
    print("ok")
except Exception as e:
    print(type(e).__name__, e)
