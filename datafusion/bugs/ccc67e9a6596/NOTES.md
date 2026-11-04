repro.sql runs RANGE window frames with value offsets near i64::MAX / i64::MIN
(`CURRENT ROW AND 4 FOLLOWING` and `4 PRECEDING AND CURRENT ROW`), copied from the
window.slt tests added by the fix.

df-clean returns the expected rows (exit 0). df-buggy lets the boundary
computation wrap around, and panics in nth_value.rs with
"attempt to subtract with overflow" (exit 101).
