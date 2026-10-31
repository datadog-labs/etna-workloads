from email import _header_value_parser as parser
try:
    a, rest = parser.get_address('<T@[')
    print(repr(str(a)), repr(rest), [type(d).__name__ for d in a.all_defects])
except Exception as e:
    print(type(e).__name__, e)
