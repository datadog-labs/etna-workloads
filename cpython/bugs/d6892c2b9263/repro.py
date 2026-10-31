import codecs, copy, io, pickle
w = codecs.getwriter('utf-8')(io.BytesIO())
for name, fn in [('copy', copy.copy), ('deepcopy', copy.deepcopy),
                 ('pickle', lambda o: pickle.dumps(o, 2))]:
    try:
        fn(w)
        print(name, 'ok')
    except Exception as e:
        print(name, type(e).__name__, e)
