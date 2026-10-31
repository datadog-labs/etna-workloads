from email import _header_value_parser as p
try:
    g, rest = p.get_group('Monty Python:"Fred A. Bear" <dinsdale@example.com>,eric@where.test,John <jdoe@test>')
    print(repr(str(g)), repr(rest), g.all_defects)
except Exception as e:
    print(type(e).__name__, e)
