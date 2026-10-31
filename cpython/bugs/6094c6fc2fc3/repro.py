import logging, logging.handlers, os
h = logging.handlers.RotatingFileHandler('x.log', maxBytes=1, backupCount=1)
l = logging.getLogger('r'); l.addHandler(h); l.propagate = False
l.warning('a long message')
h.close()
print(sorted(os.listdir('.')))
with open('x.log') as f: print(repr(f.read()))
