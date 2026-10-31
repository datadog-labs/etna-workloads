from email import _header_value_parser as p, errors
try:
    p.get_word('(Recipients list suppressed')
except errors.HeaderParseError as e:
    print('HeaderParseError', e)
except Exception as e:
    print(type(e).__name__, e)
