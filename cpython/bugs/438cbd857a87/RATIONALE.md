# Rationale

Fix gh-131146 added `calendar.standalone_month_name`/`standalone_month_abbr`
and made `TextCalendar.formatmonthname` and `HTMLCalendar.formatmonthname` use
them. v3.15.2 has this plus an extra fallback for systems that echo `%OB`.
Changes in `tree/Lib/calendar.py` (pre-fix state restored):

- `__all__`: removed the two `standalone_*` names (fix's `__all__` hunk).
- Removed the `try/except/else` block defining `standalone_month_name` and
  `standalone_month_abbr`, including the later "non-distinct names" fallback
  (fix's definition hunk; the fallback only exists to support that code).
- `TextCalendar.formatmonthname` and `HTMLCalendar.formatmonthname` use
  `month_name[...]` again (fix's two formatmonthname hunks). Month headings
  are genitive in locales like Polish/Greek.

Failing oracle cases: `test_months` (standalone attrs missing) and
`test_standalone_month_name_and_abbr_C_locale` (AttributeError); `test__all__`
is expected to fail on the same basis.
