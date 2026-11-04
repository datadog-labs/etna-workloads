Reproducer: `extract(epoch from <interval>)` for MonthDayNano, DayTime and YearMonth intervals.
Clean build returns total seconds (900, 86400, 2592000, 259200, 5184000, 2764800.5).
Buggy build returns only the interval's seconds field (0 for these, 0.5 for the last one).
