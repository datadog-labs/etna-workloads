import logging.handlers

h = logging.handlers.TimedRotatingFileHandler(
    'x.log', when='MIDNIGHT', interval=2, utc=True, delay=True)
t = 1700000000
print(h.computeRollover(t) - t)
