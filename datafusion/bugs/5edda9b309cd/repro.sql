SELECT extract(epoch from interval '15 minutes');
SELECT extract(epoch from interval '1 day');
SELECT extract(epoch from interval '1 month');
SELECT extract(epoch from arrow_cast('3 days', 'Interval(DayTime)'));
SELECT extract(epoch from arrow_cast('2 months', 'Interval(YearMonth)'));
SELECT extract(epoch from arrow_cast('1 month 2 days 500 milliseconds', 'Interval(MonthDayNano)'));
