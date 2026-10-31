import locale
try:
    print(repr(locale._parse_localename('UTF-8')))
except ValueError as e:
    print('ValueError:', e)
