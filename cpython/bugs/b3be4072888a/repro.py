import codecs, encodings.ascii, io
bio = io.BytesIO()
codec = codecs.lookup('ascii')
sr = codecs.StreamRecoder(bio, codec.encode, codec.decode,
                          encodings.ascii.StreamReader, encodings.ascii.StreamWriter)
sr.writelines([b'a', b'b'])
print(repr(bio.getvalue()))
