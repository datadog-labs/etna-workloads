repro.sql runs `time ± interval` queries (time + interval, interval + time, time - interval, Time32(s) input, and arrow_typeof).
Clean build returns a wrapped `time` (e.g. 22:00 + 3h = 01:00:00, 02:00 - 3h = 23:00:00).
Buggy build returns an Interval (25 hours, -1 hours, type Interval(MonthDayNano)).
