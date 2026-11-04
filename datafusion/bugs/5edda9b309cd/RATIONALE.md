# Rationale

Fix hunk reversed: `epoch()` in `datafusion/functions/src/datetime/date_part.rs`.
The 55.2.0 code already had the fix's three interval arms (YearMonth, DayTime,
MonthDayNano) plus `Duration(_) => seconds(...)`. I restored the pre-fix single arm
`Interval(_) | Duration(_) => return seconds(array, Second)`, which extracts only the
seconds component of an interval (0 for "15 minutes"). I also removed the
`DAYS_PER_MONTH` const and the `ArrowIntervalUnit` / `as_interval_*_array` imports,
which the fix added and which are unused without the arms. The doc-text hunk was not reverted.

Failing oracle cases (date_part.slt, epoch from interval): '15 minutes', '1 hour',
'1 day', '1 month', DayTime '3 days' and the MonthDayNano mixed case return 0 or
only the seconds part (e.g. 0.5 instead of 2764800.5); the YearMonth case errors
with "Second does not support: Interval(YearMonth)".
