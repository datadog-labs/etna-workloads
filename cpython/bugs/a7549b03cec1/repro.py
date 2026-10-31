import typing
class M(type):
    __hash__ = None
class A(metaclass=M): ...
class B(metaclass=M): ...
for f in (lambda: (A | B).__args__, lambda: typing.Union[A, B].__args__,
          lambda: typing.get_args(typing.Annotated[int, {}] | typing.Annotated[int, set()] | int)):
    try: print(f())
    except Exception as e: print(type(e).__name__, e)
for f in (lambda: hash(A | B), lambda: hash(int | B)):
    try: print(hash(f()))
    except Exception as e: print(type(e).__name__, e)
