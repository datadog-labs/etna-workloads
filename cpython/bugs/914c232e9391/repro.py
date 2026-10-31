import configparser
cfg = configparser.ConfigParser(allow_unnamed_section=True)
cfg.read_string('a = 1')
cfg.read_string('b = 2')
U = configparser.UNNAMED_SECTION
print(repr(cfg.sections()))
print(repr(dict(cfg[U])))
