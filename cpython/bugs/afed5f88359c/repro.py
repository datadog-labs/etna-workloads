from functools import partial, Placeholder
try:
    p = partial(print, a=Placeholder)
    print("no error", p.keywords)
except TypeError as e:
    print("TypeError:", e)
