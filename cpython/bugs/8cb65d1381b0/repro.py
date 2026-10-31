from email import _header_value_parser as parser, errors
from email.utils import parseaddr

for s in ('star@a.star@example.com', 'star@a@example.com', 'star@172.17.0.1@example.com'):
    try:
        print(repr(parser.get_addr_spec(s)))
    except errors.HeaderParseError as e:
        print('HeaderParseError', e)

print(parseaddr('a@malicious.org@important.com'))
