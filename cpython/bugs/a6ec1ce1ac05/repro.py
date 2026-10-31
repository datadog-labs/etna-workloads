import codecs, io

bio = io.BytesIO('line1\nline2\nline3\n'.encode('utf-16-le'))
sr = codecs.EncodedFile(bio, 'utf-8', 'utf-16-le')
print(repr(sr.readline()))
sr.seek(0)
for _ in range(4):
    print(repr(sr.readline()))
