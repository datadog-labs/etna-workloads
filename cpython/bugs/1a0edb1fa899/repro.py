from email import quoprimime
print(repr(quoprimime.decode('abc', eol='\r\n')))
print(repr(quoprimime.decode('a\r\nb', eol='\r\n')))
