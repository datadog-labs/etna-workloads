# Rationale

Fix gh-126476 added `_validate_month(themonth)` to `TextCalendar.formatmonthname`
and `HTMLCalendar.formatmonthname`, so bad months raise `IllegalMonthError`
rather than a bare `IndexError` from `month_name[themonth]`.

Changes in `tree/Lib/calendar.py`:
- Removed `_validate_month(themonth)` from `TextCalendar.formatmonthname`
  (reverses the fix hunk at `@@ -370`; v3.15.2 indexes `standalone_month_name`).
- Removed `_validate_month(themonth)` from `HTMLCalendar.formatmonthname`
  (reverses the hunk at `@@ -500`).

Left alone: `monthrange`'s validation, `IllegalMonthError(ValueError, IndexError)`
and the CLI check. In v3.15.2 the CLI check sits in an `else:` branch and is
unrelated to the oracle cases.

Oracle failures: `TextCalendar().formatmonth(2017, 13)` and
`HTMLCalendar().formatmonth(2017, 13)` now raise a plain `IndexError`
(list index out of range), not `IllegalMonthError`. `check.sh` reports 2 errors,
which are the two `test_formatmonth_with_invalid_month` tests.
