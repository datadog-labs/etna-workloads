class EvilIter:
    def __iter__(self):
        return self

    def __next__(self):
        return next(source)

    def __length_hint__(self):
        return 0


# ASCII digits so float() takes the fast path expecting a NUL terminator.
source = iter(b'42')
ba = bytearray()
ba.extend(EvilIter())

try:
    result = float(bytearray())
except ValueError as e:
    print('ValueError', e)
else:
    print('no exception', repr(result))
