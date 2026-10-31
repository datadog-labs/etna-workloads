import configparser
p = configparser.ConfigParser(comment_prefixes="", allow_no_value=True,
                              strict=False, delimiters=('=',), interpolation=None)
try:
    p.read_file(['[SECT]\n', 'KEY1\n', ' KEY2 = VAL2\n'])
except Exception as e:
    print(type(e).__name__, repr(str(e)))
else:
    print({k: dict(v) for k, v in p.items()})
