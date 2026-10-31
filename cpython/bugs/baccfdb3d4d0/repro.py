import traceback

class A:
    def __dir__(self):
        return ['bar', 1, None]

try:
    A().baz
except AttributeError as e:
    print(''.join(traceback.TracebackException.from_exception(e).format_exception_only()))
