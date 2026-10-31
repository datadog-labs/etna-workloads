from itertools import zip_longest

exception = TypeError()

class BadIterable:
    def __iter__(self):
        raise exception

for f in (zip, zip_longest):
    try:
        f(BadIterable())
    except TypeError as e:
        print(f.__name__, e is exception, e)
