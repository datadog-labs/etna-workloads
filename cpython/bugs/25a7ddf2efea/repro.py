import configparser, io
for key in ('a=b', '[this parses back as a section]'):
    cfg = configparser.ConfigParser(delimiters=('=',))
    cfg.add_section('s')
    cfg.set('s', key, 'c')
    out = io.StringIO()
    try:
        cfg.write(out)
        print('wrote', repr(out.getvalue()))
    except configparser.Error as e:
        print(type(e).__name__, e)
