import logging.handlers, os
for n in ['a.log.2024-01-01_00-00-00', 'a.log.b.2024-01-01_00-00-00', 'a.log.2024-01-01_00-00-00.c']:
    open(n, 'w').close()
h = logging.handlers.TimedRotatingFileHandler('a.log', when='s', interval=5, backupCount=1, delay=True)
print(sorted(os.path.basename(f) for f in h.getFilesToDelete()))
