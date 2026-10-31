from xml.sax import make_parser
for arg in (('module',), {'module'}, frozenset({'module'}), {'module': None}, iter(['module']), set(), iter([])):
    try:
        make_parser(arg)
        print(type(arg).__name__, 'ok')
    except Exception as e:
        print(type(arg).__name__, type(e).__name__, e)
