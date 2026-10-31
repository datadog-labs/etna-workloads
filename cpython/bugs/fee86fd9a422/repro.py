import logging.handlers, datetime, calendar
h = logging.handlers.TimedRotatingFileHandler('x.log', when='MIDNIGHT', utc=True, atTime=datetime.time(0, 0, 0), delay=True)
t = calendar.timegm((2024, 1, 1, 0, 0, 0))
print(h.computeRollover(t) - t)
