import configparser, io
cfg = configparser.ConfigParser(allow_unnamed_section=True)
cfg.add_section(configparser.UNNAMED_SECTION)
cfg.add_section('section')
out = io.StringIO()
cfg.write(out)
print(repr(out.getvalue()))
