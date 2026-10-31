import calendar
for f in (calendar.TextCalendar().formatmonth, calendar.HTMLCalendar().formatmonth):
    for m in (13, -1):
        try:
            print(repr(f(2017, m))[:60])
        except Exception as e:
            print(type(e).__name__, e)
