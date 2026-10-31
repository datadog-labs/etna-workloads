import codecs, warnings
warnings.simplefilter("always")
decode = codecs.unicode_escape_decode
for data in (b'\\z', b'\\501', b'\\\xfa', b'\\x\\z', b'\\x\\501'):
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        print(data, repr(decode(data, 'ignore')), [str(x.message) for x in w])

data = {br'\x3': (b'xxx\\', 3)}
def mutating(exc):
    r = data.get(exc.object[:exc.end])
    exc.object = r[0] + exc.object[exc.end:]
    return ('Є', r[1])
codecs.register_error('m', mutating)
with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    print(repr(decode(br'\x3zr', 'm')), [str(x.message) for x in w])
