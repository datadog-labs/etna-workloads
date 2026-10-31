from email import _header_value_parser as p, errors
for f in (p.get_local_part, p.get_domain, p.get_angle_addr, p.get_name_addr, p.get_quoted_string):
    try:
        print(f.__name__, repr(f('')))
    except errors.HeaderParseError as e:
        print(f.__name__, 'HeaderParseError', e)
    except Exception as e:
        print(f.__name__, type(e).__name__)
