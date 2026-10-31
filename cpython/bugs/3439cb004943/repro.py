import codecs, copy
orig = codecs.lookup('base64')
for f in (copy.copy, copy.deepcopy):
    try:
        dup = f(orig)
        print(dup == orig, dup._is_text_encoding, dup.name)
    except Exception as e:
        print(type(e).__name__, e)
