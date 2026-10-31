for e in (UnicodeEncodeError('x', 'abc', -1, 0, 'why'),
          UnicodeDecodeError('x', b'abc', -1, 0, 'why'),
          UnicodeTranslateError('abc', -1, 0, 'why')):
    print(repr(str(e)))
