from contextlib import contextmanager, ExitStack

class MyException(Exception):
    pass

@contextmanager
def my_cm():
    try:
        yield
    except BaseException:
        exc = MyException()
        try:
            raise exc
        finally:
            exc.__context__ = None

@contextmanager
def my_cm_with_exit_stack():
    with ExitStack() as stack:
        stack.enter_context(my_cm())
        yield stack

for cm in (my_cm, my_cm_with_exit_stack):
    try:
        with cm():
            raise Exception("inner")
    except MyException as e:
        print(cm.__name__, repr(e.__context__))
