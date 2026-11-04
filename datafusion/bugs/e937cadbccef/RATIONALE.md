# date_bin(NULL, ...) regression

Hunks changed (in `tree/`):

1. `datafusion/expr/src/type_coercion/functions.rs` (`coerced_from`, ~line 1203): reverses the fix's coercion hunk. `(Interval(_), Null | Utf8 | LargeUtf8 | Utf8View)` becomes `(Interval(_), Utf8 | LargeUtf8 | Utf8View)`, so Null no longer coerces to Interval. The other variants are unchanged from the pre-fix arm; Utf8View was added after the fix.
2. `datafusion/functions/src/datetime/date_bin.rs` (`date_bin_impl`): removes the `ColumnarValue::Scalar(s) if s.is_null()` early return that the fix added. A NULL stride no longer short-circuits to a NULL result.

Oracle (`timestamps.slt`): 3 queries fail, at lines 810, 816 and 5528. All three are `date_bin(NULL, ...)` calls. They fail with "DATE_BIN expects stride argument to be an INTERVAL but got Interval(MonthDayNano)". They should return NULL.

In 55.2.0 the planning error from the fix's issue does not reappear. Another path still coerces the NULL to an Interval, so the failure comes from execution. The user-visible symptom is the same: `date_bin(NULL, ...)` errors instead of returning NULL.
