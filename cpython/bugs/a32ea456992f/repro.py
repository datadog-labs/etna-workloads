from email import _header_value_parser as p
for f in (p.get_dtext, p.get_qcontent):
    try:
        print(repr(f('')))
    except Exception as e:
        print(f.__name__, type(e).__name__, e)
try:
    m = p.parse_message_id('<T@[')
    print(repr(str(m)), [str(d) for d in m.all_defects])
except Exception as e:
    print(type(e).__name__, e)
