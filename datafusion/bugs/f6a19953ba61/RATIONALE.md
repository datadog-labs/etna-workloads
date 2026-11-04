# Rationale

Fix: `date_part('isodow')` must return 1..=7 (Mon=1). In 55.2.0 this was done via Arrow's `DatePart::DayOfWeekMonday1`, so the fix hunks could not be reversed literally.

1. `datafusion/functions/src/datetime/date_part.rs`: the `"isodow"` arm now uses `DatePart::DayOfWeekMonday0` (0..=6, Mon=0), which is the pre-fix kernel call. The doc string reverts to "Monday is 0".
2. `datafusion/spark/src/function/datetime/date_part.rs`: `"dow" | "isodow"` again get the +1 shift. This restores the pre-fix pairing with the 0-based isodow (the fix removed it), so Spark `dayofweek_iso` is correct and the two changes stay consistent.

Oracle: `datetime/date_part.slt` fails 4 cases (isodow of 2000-01-01 gives 5 instead of 6; the three `EXTRACT(isodow ...)` of 2020-09-08 give 1 instead of 2).
