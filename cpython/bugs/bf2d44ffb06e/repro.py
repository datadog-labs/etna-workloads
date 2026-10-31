import tarfile
t = tarfile.TarInfo()
t.name = "foo"
t.mtime = 1000.1
info = t.get_info()
header = t.create_pax_header(info, encoding="iso8859-1")
print(repr(info['mtime']))
print(header[512:528])
