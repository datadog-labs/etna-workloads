from json.encoder import c_make_encoder, c_encode_basestring
enc = c_make_encoder(None, str, c_encode_basestring, '\t', ': ', ', ', False, False, False)
print(repr(enc(['spam', {'ham': 'eggs'}], 0)[0]))
print(repr(enc(['spam', {'ham': 'eggs'}], 3)[0]))
