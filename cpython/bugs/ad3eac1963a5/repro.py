import time, datetime
t = datetime.datetime(2004, 12, 31, 6, 22, 33, 47)
for fn in (lambda: time.strftime('%S\0%M', time.gmtime(0)), lambda: t.strftime('%S\0%M')):
    try:
        print(ascii(fn()))
    except Exception as e:
        print(type(e).__name__, e)
