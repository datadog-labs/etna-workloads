import mimetypes
m = mimetypes.MimeTypes()
print(m.guess_type('http://example.com/a.html?x=1.txt'))
print(m.guess_type('ftp://host/a.gif#frag.txt'))
