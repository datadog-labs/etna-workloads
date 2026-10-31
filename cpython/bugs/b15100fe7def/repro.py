import io, logging, logging.config

cfg = """
[loggers]
keys=root

[handlers]
keys=hand1

[formatters]
keys=form1

[logger_root]
handlers=hand1

[handler_hand1]
class=StreamHandler
formatter=form1

[formatter_form1]
format=%(levelname)s ++ %(message)s
"""
logging.config.fileConfig(io.StringIO(cfg))
print(repr(logging.getLogger().handlers[0].name))
