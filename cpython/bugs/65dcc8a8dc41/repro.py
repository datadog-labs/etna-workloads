from email import _header_value_parser as p, errors
try:
    p.get_encoded_word('=?utf-8?X?somevalue?=')
except errors.HeaderParseError as e:
    print('HeaderParseError', e)
