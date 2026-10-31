import traceback
class Inner:
    def __init__(self):
        self.value = 42
class Outer:
    def __init__(self):
        self.inner = Inner()
try:
    Outer().value
except AttributeError as e:
    print(''.join(traceback.TracebackException.from_exception(e).format_exception_only()))
