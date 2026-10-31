import contextvars

class S(str):
    __hash__ = None

try:
    contextvars.ContextVar(S("a"))
except TypeError as e:
    print("TypeError", e)
print("done")
